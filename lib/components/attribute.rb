module Components
  class Attribute
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def to_s
      @value
    end
  end
end
