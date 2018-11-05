module Components
  class Element
    include Attributes
    include Elements

    attr_reader :content

    def initialize(view, attributes = nil, &block)
      @view = view
      initialize_elements
      initialize_attributes(attributes)
      initialize_content(&block)
    end

    def to_h
      serialize_attributes
        .merge(serialize_content)
        .merge(serialize_elements)
    end

    protected

    def initialize_content(&block)
      @content = @view.capture(self, &block) if block
    end

    def serialize_content
      { content: content }
    end

    def serialize_elements
      elements.each_with_object({}) do |(key, value), hash|
        hash[key] =
          if value.respond_to?(:map) # should we rather check the config here?
            value.map(&:to_h)
          else
            value ? value.to_h : nil
          end
      end
    end
  end
end
