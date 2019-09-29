module Calculator
  class Number
    attr_accessor :value

    def initialize(value)
      @value = value.to_f
    end

    def to_s
      @value.to_s
    end

    def exp(n)
      @value **= n.value
      return self
    end

    def root(n)
      @value **= (1/n.value)
      return self
    end

    def multiply(n)
      @value *= n.value
      return self
    end

    def divide(n)
      @value /= n.value
      return self
    end

    def add(n)
      @value += n.value
      return self
    end

    def subtract(n)
      @value -= n.value
      return self
    end
  end
end
