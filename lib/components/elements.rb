module Components
  module Elements
    extend ActiveSupport::Concern

    class_methods do
      def elements
        @elements ||= {}
      end

      def element(name, multiple: false, &config)
        plural_name = name.to_s.pluralize.to_sym if multiple

        elements[name] = {
          multiple: plural_name || false, class: Class.new(Element, &config)
        }

        define_method(name) do |attributes = nil, &block|
          return get_element(multiple ? plural_name : name) unless attributes || block

          element = self.class.elements[name][:class].new(@view, attributes, &block)

          if multiple
            get_element(plural_name) << element
          else
            set_element(name, element)
          end
        end

        return if !multiple || name == plural_name

        define_method(plural_name) do
          get_element(plural_name)
        end
      end
    end

    protected

    def initialize_elements
      self.class.elements.each do |name, options|
        if (plural_name = options[:multiple])
          set_element(plural_name, [])
        else
          set_element(name, nil)
        end
      end
    end

    def get_element(name)
      instance_variable_get(:"@#{name}")
    end

    def set_element(name, value)
      instance_variable_set(:"@#{name}", value)
    end
  end
end
