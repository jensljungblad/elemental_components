module Components
  module Elements
    extend ActiveSupport::Concern

    class_methods do
      def elements
        @elements ||= {}
      end

      def element(name, multiple: false, &config)
        elements[name] = { class: Class.new(Element, &config), multiple: multiple }

        define_method(name) do |attributes = nil, &block|
          element = self.class.elements[name][:class].new(@view, attributes, &block)

          if multiple
            elements[name] << element
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
        elements[name] = options[:multiple] ? [] : nil
      end
    end

    def serialize_elements
      elements.each_with_object({}) do |(name, value), hash|
        hash[name] =
          if self.class.elements[name][:multiple]
            value.map(&:serialize)
          elsif value
            value.serialize
          end
      end
    end
  end
end
