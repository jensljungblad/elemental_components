module Components
  class Component
    # TODO: include Element here instead

    include Attributes
    include Elements

    def initialize(view, attributes = nil)
      @view = view
      assign_attributes(attributes || {})
    end
  end
end
