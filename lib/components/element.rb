module Components
  class Element
    include Attributes
    include Elements

    attr_reader :content

    def initialize(view, attributes = nil, &block)
      @view = view
      @content = capture(&block) if block
      assign_attributes(attributes || {})
    end

    private

    def capture(&block)
      @view.capture(self, &block)
    end
  end
end
