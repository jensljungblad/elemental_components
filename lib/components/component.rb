module Components
  class Component
    class << self
      def attributes
        @attributes ||= {}
      end

      def attribute(attribute, default: nil)
        attributes[attribute] = { default: default }

        define_method(attribute) do
          instance_variable_get("@#{attribute}")
        end
      end
    end

    def initialize(attributes)
      self.class.attributes.each do |name, options|
        instance_variable_set("@#{name}", attributes.delete(name) || options[:default])
      end
    end
  end
end
