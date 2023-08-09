# frozen_string_literal: true

module ElementalComponents
  class Element
    include ActiveModel::Validations

    def self.model_name
      ActiveModel::Name.new(ElementalComponents::Element)
    end

    def self.attributes
      @attributes ||= {}
    end

    def self.attribute(name, default: nil)
      attributes[name] = { default: default }

      define_method_or_raise(name) do
        get_instance_variable(name)
      end
    end

    def self.elements
      @elements ||= {}
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/PerceivedComplexity
    def self.element(name, multiple: false, &config)
      plural_name = name.to_s.pluralize.to_sym if multiple

      elements[name] = {
        multiple: plural_name || false, class: Class.new(Element, &config)
      }

      define_method_or_raise(name) do |attributes = nil, &block|
        return get_instance_variable(multiple ? plural_name : name) unless attributes || block

        element = self.class.elements[name][:class].new(@view, attributes, &block)

        if multiple
          get_instance_variable(plural_name) << element
        else
          set_instance_variable(name, element)
        end
      end

      return if !multiple || name == plural_name

      define_method_or_raise(plural_name) do
        get_instance_variable(plural_name)
      end
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/PerceivedComplexity

    def self.define_method_or_raise(method_name, &block)
      if method_defined?(method_name.to_sym)
        raise(ElementalComponents::Error, "Method '#{method_name}' already exists.")
      end

      define_method(method_name, &block)
    end
    private_class_method :define_method_or_raise

    def initialize(view, attributes_or_elements = nil, &block)
      @view = view
      initialize_attributes(attributes_or_elements || {})
      initialize_elements(attributes_or_elements || {})
      @yield = block_given? ? @view.capture(self, &block) : nil
      validate!
    end

    def content?
      content.present?
    end

    def content
      @yield
    end

    protected

    def initialize_attributes(attributes_or_elements)
      self.class.attributes.each do |name, options|
        set_instance_variable(name, attribute_value(attributes_or_elements, name, options[:default]))
      end
    end

    def attribute_value(attributes_or_elements, name, default)
      attributes_or_elements.key?(name) ? attributes_or_elements[name] : default.dup
    end

    def initialize_elements(attributes_or_elements)
      self.class.elements.each do |name, options|
        if (plural_name = options[:multiple])
          set_instance_variable(plural_name, [])

          if (plural_values = element_value(attributes_or_elements, plural_name))
            plural_values.each { |plural_value| initialize_element(name, plural_value) }
          end
        else
          set_instance_variable(name, nil)

          if (single_value = element_value(attributes_or_elements, name))
            initialize_element(name, single_value)
          end
        end
      end
    end

    def initialize_element(name, value)
      value.is_a?(Hash) ? send(name.to_sym, value) : send(name.to_sym, {}) { value }
    end

    def element_value(attributes_or_elements, name)
      attributes_or_elements.key?(name) ? attributes_or_elements[name] : nil
    end

    private

    def get_instance_variable(name)
      instance_variable_get(:"@#{name}")
    end

    def set_instance_variable(name, value)
      instance_variable_set(:"@#{name}", value)
    end
  end
end
