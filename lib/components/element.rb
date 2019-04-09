module Components
  class Element
    include ActiveModel::Validations

    def self.model_name
      ActiveModel::Name.new(Components::Element)
    end

    attr_accessor :_name, :block_content
    attr_reader :parents

    def self.attributes
      @attributes ||= {}
    end

    def self.classnames
      @classnames ||= []
    end

    def self.add_class(*args)
      classnames.push(*args)
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
    def self.element(name, multiple: false, extends: nil, &config)
      plural_name = name.to_s.pluralize.to_sym if multiple

      # Allow elements to extend components by class or by component string
      # e.g. `extends: 'core/header'` or extends: Core::HeaderComponent
      extends = "#{extends}_component".classify.constantize if extends.is_a?(String)

      # When inheriting elements by extending a Component,
      # extend elements from that component's elements
      extends ||= elements[name][:class] if elements[name]

      elements[name] = {
        multiple: plural_name || false, class: Class.new(extends || Element, &config)
      }

      define_method_or_raise(name) do |attributes = nil, &block|
        return get_instance_variable(multiple ? plural_name : name) unless attributes || block

        element = self.class.elements[name][:class].new(@view, attributes, &block)

        # Allow elements to reference their parent component
        element.parent = self
        # Allow elements to reference their own names
        element._name = name

        element.block_content = element.render if element.respond_to?(:render)

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

    # Pass on attributes and elements to subclassed elements/components
    def self.inherited(subclass)
      subclass.add_class classnames

      attributes.each do |name, options|
        subclass.attribute(name, options)
      end

      elements.each do |name, options|
        subclass.elements[name] = options
      end
    end

    def initialize(view, attributes = nil, &block)
      @view = view
      @options ||= {}
      @parents = []
      @classnames = self.class.classnames
      initialize_attributes(attributes || {})
      initialize_elements
      @block_content = block_given? ? @view.capture(self, &block) : nil
      validate!
    end

    def parent=(obj)
      @parents = [obj.parents, obj].flatten.compact
    end

    def parent
      parents.last
    end

    def render_partial(file)
      @view.render(partial: file, object: self)
    end

    def add_class(*args)
      @classnames.push(*args)
    end

    def classnames
      @classnames.join(' ').strip
    end

    def to_s
      block_content
    end

    protected

    def initialize_attributes(attributes)
      self.class.attributes.each do |name, options|
        @options[name] = attributes[name] || (options[:default] && options[:default].dup)
        set_instance_variable(name, @options[name])
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
