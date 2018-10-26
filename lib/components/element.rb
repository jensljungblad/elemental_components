module Components
  class Element
    include Attributes
    include Elements

    attr_accessor :value

    def initialize(view, value = nil, attributes = nil, &block)
      @view = view
      @value = block ? capture(&block) : value
      assign_attributes(attributes || {})
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
