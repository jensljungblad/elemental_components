module Components
  class Element
    include Attributes
    include Elements

    attr_accessor :value

    def initialize(view, value, attributes = nil)
      @view = view
      @value = value
      assign_attributes(attributes || {})
    end

    def to_s
      @value
    end
  end
end
