module Components
  class Attribute
    attr_accessor :value
    attr_accessor :attributes

    delegate_missing_to :@value

    def initialize(value, attributes = {})
      @value = value
      @attributes = attributes
    end

    def to_s
      @value
    end
  end
end
