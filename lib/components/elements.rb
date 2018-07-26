module Components
  module Elements
    extend ActiveSupport::Concern

    class_methods do
      def element(name, collection: false, &config)
        define_method(name) do |value = nil, attributes = nil, &block|
          attributes, value = value, @view.capture(&block) if block

          if value
            element_class = config ? Class.new(Element, &config) : Element

            set_element(
              name, element_class.new(@view, value, attributes), collection: collection
            )
          else
            get_element(name, collection: collection)
          end
        end
      end
    end

    private

    def get_element(name, collection: false)
      unless instance_variable_defined?(:"@#{name}")
        instance_variable_set(:"@#{name}", collection ? [] : Element.new(@view, nil))
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
