module Components
  class Element
    include Attributes
    include Elements

    def initialize(view, attributes = nil, &block)
      @view = view
      initialize_attributes(attributes || {})
      initialize_elements
      @yield = block ? @view.capture(self, &block) : nil
    end

    def to_s
      @yield
    end
  end
end
