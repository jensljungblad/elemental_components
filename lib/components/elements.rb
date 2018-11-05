module Components
  module Elements
    extend ActiveSupport::Concern

    class_methods do
      def elements
        @elements ||= {}
      end

      def element(name, multiple: false, &config)
        elements[name] = { multiple: multiple }

        define_method(name) do |attributes = nil, &block|
          # TODO: we should store the class in the config, so we don't have to create
          # a new class every time we call this method
          element = Class.new(Element, &config).new(@view, attributes, &block)

          if multiple
            elements[name] << element
          else
            elements[name] = element
          end
        end
      end
    end

    protected

    def elements
      @elements ||= {}
    end

    def initialize_elements
      self.class.elements.each do |name, options|
        elements[name] = options[:multiple] ? [] : nil
      end
    end
  end
end
