module Components
  module Elements
    extend ActiveSupport::Concern

    class_methods do
      def element(name, multiple: false, &config)
        plural_name = name.to_s.pluralize.to_sym if multiple

        define_method(name) do |attributes = nil, &block|
          return get_element(multiple ? plural_name : name, multiple: multiple) unless attributes || block

          element_class = Class.new(Element, &config)

          set_element(
            multiple ? plural_name : name,
            element_class.new(@view, attributes, &block),
            multiple: multiple
          )
        end

        return unless multiple || name == plural_name

        define_method(plural_name) do
          get_element(name, multiple: multiple)
        end
      end
    end

    private

    def get_element(name, multiple: false)
      unless instance_variable_defined?(:"@#{name}")
        instance_variable_set(:"@#{name}", multiple ? [] : nil)
      end
      instance_variable_get(:"@#{name}")
    end

    def set_element(name, value, multiple: false)
      if multiple
        get_element(name, multiple: multiple) << value
      else
        instance_variable_set(:"@#{name}", value)
      end
    end
  end
end
