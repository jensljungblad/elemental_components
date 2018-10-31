module Components
  class Element
    include Attributes
    include Elements

    attr_reader :value

    def initialize(view, attributes = nil, &block)
      @view = view
      attributes ||= {}
      @value = attributes.delete(:value)
      @value = capture(&block) if block
      assign_attributes(attributes)
    end

    def to_s
      @value
    end

    private

    def capture(&block)
      @view.capture(self, &block)
    end
  end
end
