module Components
  class Element
    include Attributes
    include Elements

    # TODO: this works when inheriting from element, but not when instantiating an element directly..
    # is that an issue? it would sorta be better if attributes could be inherited? otherwise you
    # can't inherit components either.. come to think of it..
    def self.inherited(other)
      other.attribute :value
    end

    # attr_accessor :value

    # def initialize(view, value = nil, attributes = nil, &block)
    #   @view = view
    #   @value = block ? capture(&block) : value
    #   assign_attributes(attributes || {})
    # end

    def initialize(view, attributes = nil, &block)
      @view = view
      attributes ||= {}
      attributes[:value] = capture(&block) if block
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
