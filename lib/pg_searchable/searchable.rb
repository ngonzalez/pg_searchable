module Searchable
  extend ActiveSupport::Concern

  included do
    # Inherited by subclasses, so STI models search with their parent's fields
    class_attribute :searchable_fields, instance_writer: false, default: []
  end

  module ClassMethods
    def searchable *names
      self.searchable_fields = names
    end

    def join_table_field_names
      searchable_fields.select { |item| item.is_a?(Hash) }
    end

    def field_names
      searchable_fields - join_table_field_names
    end

    def each_field_name &block
      field_names.each do |name|
        yield name if block_given?
      end
    end

    def get_class_name class_name, name
      if class_name.reflect_on_association(name) && class_name.reflect_on_association(name).options.has_key?(:class_name)
        class_name.reflect_on_association(name).options[:class_name].classify.constantize
      else
        name.to_s.classify.constantize
      end
    end

    def each_join_table &block
      join_table_field_names.each do |item|
        item.each do |table_name, field_names|
          if field_names.is_a?(Hash)
            field_names.each do |sub_table_name, sub_field_names|
              yield get_class_name(get_class_name(self, table_name), sub_table_name).table_name, sub_field_names if block_given?
            end
          else
            yield get_class_name(self, table_name).table_name, field_names if block_given?
          end
        end
      end
    end

    # Text search configuration for the current locale, `simple` for other locales
    def get_locale
      case I18n.locale.to_sym
      when :en then :english
      when :fr then :french
      else :simple
      end
    end

    # Full-text and substring conditions for a column, with bound values
    def text_search_condition table_name, name, words
      column = "#{connection.quote_table_name(table_name)}.#{connection.quote_column_name(name)}"
      sanitize_sql_array([
        "to_tsvector(?, #{column}) @@ to_tsquery(?, ?) OR #{column} ILIKE ?",
        get_locale.to_s, get_locale.to_s, words.join(" & "), "%#{sanitize_sql_like(words.join(" "))}%"
      ])
    end

    def searchable_fields_conditions words
      array = []
      each_field_name do |name|
        array << text_search_condition(self.table_name, name, words)
      end
      each_join_table do |join_table_name, field_names|
        field_names.each do |name|
          array << text_search_condition(join_table_name, name, words)
        end
      end
      array
    end

    def join_table_names
      searchable_fields.each_with_object([]) do |item, array|
        if item.is_a?(Hash)
          item.each do |table_name, field_names|
            array << table_name
            if field_names.is_a?(Hash)
              field_names.each do |sub_table_name, _sub_field_names|
                array << { table_name => sub_table_name }
              end
            end
          end
        end
      end
    end

    # Words to search: letters (including accented letters) and digits only
    def search_words keywords
      keywords.to_s.gsub(/[^[:alnum:]]+/, " ").split(" ")
    end

    def parse_keywords keywords
      search_words(keywords).join(" & ")
    end

    # Returns a relation (`id IN (subquery)`): it can be chained, ordered and
    # combined with `or`, and each record is returned once without DISTINCT.
    # Returns no records for blank keywords.
    def search keywords=""
      words = search_words(keywords)
      return none if words.empty?

      where(id: left_outer_joins(join_table_names)
                  .where(searchable_fields_conditions(words).join(" OR "))
                  .select(:id))
    end

  end
end

ActiveRecord::Base.send(:include, Searchable)
