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
          multiple: plural_name, class: Class.new(Element, &config)
        }

        define_method(name) do |attributes = nil, &block|
          element = self.class.elements[name][:class].new(@view, attributes, &block)

          if multiple
            elements[plural_name] << element
          else
            elements[name] = element
          end
        end
      end
    end

    protected

    def elements
      @elements ||= {}
    end

    def initialize_elements
      self.class.elements.each do |name, options|
        if (plural_name = options[:multiple])
          elements[plural_name] = []
        else
          elements[name] = nil
        end
      end
    end

    def serialize_elements
      self.class.elements.each_with_object({}) do |(name, options), hash|
        if (plural_name = options[:multiple])
          hash[plural_name] = elements[plural_name].map(&:serialize)
        else
          hash[name] = elements[name] && elements[name].serialize
        end
      end
    end
  end
end
