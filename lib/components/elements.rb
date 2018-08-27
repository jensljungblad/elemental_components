module Components
  module Elements
    extend ActiveSupport::Concern

    class_methods do
      def has_one(name, &config)
        define_method(name) do |value = nil, attributes = nil, &block|
          attributes, value = value, @view.capture(&block) if block

          if value
            element_class = config ? Class.new(Element, &config) : Element

            set_element(
              name, element_class.new(@view, value, attributes)
            )
          else
            get_element(name)
          end
        end
      end

      def has_many(name, &config)
        define_method(name) do |value = nil, attributes = nil, &block|
          attributes, value = value, @view.capture(&block) if block

          if value
            element_class = config ? Class.new(Element, &config) : Element

            set_element(
              name, element_class.new(@view, value, attributes), collection: true
            )
          else
            get_element(name, collection: true)
          end
        end
      end
    end

    private

    def get_element(name, collection: false)
      unless instance_variable_defined?(:"@#{name}")
        instance_variable_set(:"@#{name}", collection ? [] : nil)
      end
      instance_variable_get(:"@#{name}")
    end

    def set_element(name, value, collection: false)
      if collection
        get_element(name, collection: collection) << value
      else
        instance_variable_set(:"@#{name}", value)
      end
    end
  end
end
