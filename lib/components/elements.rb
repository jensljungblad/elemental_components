module Components
  module Elements
    extend ActiveSupport::Concern

    # rubocop:disable Naming/PredicateName
    class_methods do
      def has_one(name, &config)
        define_method(name) do |value = nil, attributes = nil, &block|
          return get_element(name) unless value || block

          element_class = config ? Class.new(Element, &config) : Element

          set_element(
            name, element(element_class, value, attributes, &block)
          )
        end
      end

      def has_many(name, &config)
        define_method(name) do |value = nil, attributes = nil, &block|
          return get_element(name, collection: true) unless value || block

          element_class = config ? Class.new(Element, &config) : Element

          set_element(
            name, element(element_class, value, attributes, &block), collection: true
          )
        end
      end
    end
    # rubocop:enable Naming/PredicateName

    private

    def element(element_class, value, attributes, &block)
      attributes, value = value, nil if block
      element_class.new(@view, value, attributes, &block)
    end

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
