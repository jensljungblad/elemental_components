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

    # TODO: consider skipping yield altogether if none was set
    def serialize
      { yield: @yield }
        .merge(serialize_attributes)
        .merge(serialize_elements)
    end
  end
end
