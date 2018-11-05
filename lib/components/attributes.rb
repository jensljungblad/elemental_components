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
        self.attributes[name] = attributes.delete(name) || (options[:default] && options[:default].dup)
      end
    end

    # TODO: this shouldn't modify the attributes hash.. instead it should
    # return a new hash..
    def serialize_attributes
      attributes.tap do |hash|
        self.class.attributes.each do |name, options|
          if options[:block]
            hash[name] = instance_exec(hash[name], &options[:block])
          end
        end
      end
    end
  end
end
