module Components
  class Component
    class << self
      def attributes
        @attributes ||= {}
      end

      def attribute(name, default: nil)
        attributes[name] = { default: default }

        define_method(name) do |value = nil, &block|
          value = @view.capture(&block) if block

          if value
            set_attribute(name, value)
          else
            get_attribute(name)
          end
        end
      end
    end

    def initialize(view, attributes)
      @view = view

      self.class.attributes.each do |name, options|
        set_attribute(name, attributes.delete(name) || options[:default])
      end
    end

    private

    def get_attribute(name)
      instance_variable_get("@#{name}")
    end

    def set_attribute(name, value)
      instance_variable_set("@#{name}", Attribute.new(value))
    end
  end
end
