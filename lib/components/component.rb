module Components
  class Component
    include Attributes

    def self.element(name, collection: false, &config)
      element_class = Class.new(Element, &config)

      define_method(name) do |value = nil, attributes = nil, &block|
        attributes, value = value, @view.capture(&block) if block

        if value
          element = element_class.new(@view, value, attributes)

          if collection
            unless instance_variable_defined?(:"@#{name}")
              instance_variable_set(:"@#{name}", [])
            end
            instance_variable_get(:"@#{name}") << element
          else
            instance_variable_set(:"@#{name}", element)
          end
        else
          instance_variable_get(:"@#{name}")
        end
      end
    end

    def initialize(view, attributes = nil)
      @view = view
      assign_attributes(attributes || {})
    end
  end
end
