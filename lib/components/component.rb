module Components
  class Component
    include Attributes
    include Elements

    def initialize(view, attributes = nil)
      @view = view
      assign_attributes(attributes || {})
    end
  end
end
