module Components
  class Element
    include ActiveModel::Validations

    attr_accessor :yield

    def self.model_name
      ActiveModel::Name.new(Components::Element)
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
    def self.element(name, multiple: false, component: nil, &config)
      plural_name = name.to_s.pluralize.to_sym if multiple

      # Extend components by string or class; e.g., "core/header" or Core::HeaderComponent
      component = "#{component}_component".classify.constantize if component.is_a?(String)

      elements[name] = {
        multiple: plural_name || false, class: Class.new(component || Element, &config)
      }

      define_method_or_raise(name) do |attributes = nil, &block|
        return get_instance_variable(multiple ? plural_name : name) unless attributes || block

        element = self.class.elements[name][:class].new(@view, attributes, &block)
        element.yield = element.render if element.respond_to?(:render)

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
      # Select instance methods but not those which are intance methods received by extending a class
      methods = (instance_methods - superclass.instance_methods(false))
      raise(Components::Error, "Method '#{method_name}' already exists.") if methods.include?(method_name.to_sym)

      define_method(method_name, &block)
    end
    private_class_method :define_method_or_raise

    def self.inherited(subclass)
      attributes.each { |name, options| subclass.attribute(name, options) }
      elements.each   { |name, options| subclass.elements[name] = options }
    end

    def initialize(view, attributes = nil, &block)
      @view = view
      initialize_attributes(attributes || {})
      initialize_elements
      @yield = block_given? ? @view.capture(self, &block) : nil
      validate!
    end

    def to_s
      @yield
    end

    protected

    def initialize_attributes(attributes)
      self.class.attributes.each do |name, options|
        set_instance_variable(name, attributes[name] || (options[:default] && options[:default].dup))
      end
    end

    def initialize_elements
      self.class.elements.each do |name, options|
        if (plural_name = options[:multiple])
          set_instance_variable(plural_name, [])
        else
          set_instance_variable(name, nil)
        end
      end
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
