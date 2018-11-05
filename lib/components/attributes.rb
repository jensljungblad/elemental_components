module Components
  module Attributes
    extend ActiveSupport::Concern

    class_methods do
      def attributes
        @attributes ||= {}
      end

      def attribute(name, default: nil, &block)
        attributes[name] = { default: default, block: block }
      end
    end

    protected

    def attributes
      @attributes ||= {}
    end

    def initialize_attributes(attributes)
      attributes ||= {}

      self.class.attributes.each do |name, options|
        self.attributes[name] = attributes[name] || (options[:default] && options[:default].dup)
      end
    end

    def serialize_attributes
      attributes.each_with_object({}) do |(name, value), hash|
        hash[name] =
          if (block = self.class.attributes[name][:block])
            instance_exec(value, &block)
          else
            value
          end
      end
    end
  end
end
