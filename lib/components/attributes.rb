module Components
  module Attributes
    extend ActiveSupport::Concern

    class_methods do
      def attributes
        @attributes ||= {}
      end

      def attribute(name, default: nil)
        attributes[name] = { default: default }

        define_method(name) do
          get_attribute(name)
        end
      end
    end

    private

    def assign_attributes(attributes = {})
      self.class.attributes.each do |name, options|
        set_attribute(name, attributes.delete(name) || (options[:default] && options[:default].dup))
      end
    end

    def get_attribute(name)
      instance_variable_get(:"@#{name}")
    end

    def set_attribute(name, value)
      instance_variable_set(:"@#{name}", value)
    end
  end
end
