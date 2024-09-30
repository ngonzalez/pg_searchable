module Searchable
  extend ActiveSupport::Concern

  attr_accessor :searchable_fields

  module ClassMethods
    def searchable *names
      @searchable_fields = names
    end

    def join_table_field_names
      @searchable_fields.select{|item| item.is_a?(Hash) }
    end

    def field_names
      @searchable_fields - join_table_field_names
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

    def get_locale
      case I18n.locale.to_sym
      when :en then :english
      when :fr then :french
      end
    end

    def search_condition
      "to_tsvector('#{get_locale}', %s.%s) @@ to_tsquery('#{get_locale}', '%s')"
    end

    def searchable_fields_conditions keywords
      array = []
      each_field_name do |name|
        array << search_condition % [ self.table_name, name, keywords ]
      end
      each_join_table do |join_table_name, field_names|
        field_names.each do |name|
          array << search_condition % [ join_table_name, name, keywords ]
        end
      end
      array
    end

    def join_table_names
      @searchable_fields.each_with_object([]) do |item, array|
        if item.is_a?(Hash)
          item.each do |table_name, field_names|
            array << table_name
            if field_names.is_a?(Hash)
              field_names.each do |sub_table_name, sub_field_names|
                array << { table_name => sub_table_name }
              end
            end
          end
        end
      end
    end

    def parse_keywords keywords
      keywords.gsub("\'", " ")
              .gsub("-", " ")
              .gsub("_", " ")
              .gsub(/[^0-9a-z ]/i, '')
              .split(" ")
              .join(" & ")
    end

    def search keywords=""
      self.joins(join_table_names)
          .where(searchable_fields_conditions(parse_keywords(keywords)).join(" OR "))
          .uniq
    end

  end
end

ActiveRecord::Base.send(:include, Searchable)
