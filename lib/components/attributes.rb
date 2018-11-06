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
      self.class.attributes.each do |name, options|
        self.attributes[name] = attributes[name] || (options[:default] && options[:default].dup)
      end
    end

    def serialize_attributes
      self.class.attributes.each_with_object({}) do |(name, options), hash|
        hash[name] =
          if (block = options[:block])
            instance_exec(attributes[name], &block)
          else
            attributes[name]
          end
      end
    end
  end
end
