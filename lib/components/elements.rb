module Components
  module Elements
    extend ActiveSupport::Concern

    class_methods do
      # rubocop:disable Naming/PredicateName
      def has_one(name, &config)
        define_method(name) do |attributes = nil, &block|
          return get_element(name) unless attributes || block

          element_class = config ? Class.new(Element, &config) : Element

          set_element(
            name,
            element_class.new(@view, attributes, &block)
          )
        end
      end
      # rubocop:enable Naming/PredicateName

      # rubocop:disable Naming/PredicateName
      def has_many(name, &config)
        define_method(name) do |attributes = nil, &block|
          return get_element(name, collection: true) unless attributes || block

          element_class = config ? Class.new(Element, &config) : Element

          set_element(
            name,
            element_class.new(@view, attributes, &block),
            collection: true
          )
        end
      end
      # rubocop:enable Naming/PredicateName
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
