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
          instance_variable_get("@#{name}")
        end
      end
    end

    private

    def assign_attributes(attributes = {})
      self.class.attributes.each do |name, options|
        value = attributes.delete(name) || options[:default].dup

        # unless value.present?
        #   raise "Attribute must be passed to ? or assigned a default value: #{name}"
        # end

        instance_variable_set(:"@#{name}", value)
      end

      # unless attributes.keys.empty?
      #   raise "Unknown attributes passed to ?: #{attributes.keys}"
      # end
    end
  end
end
