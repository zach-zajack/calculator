module Calculator
  class Number
    attr_accessor :value

    def initialize(value)
      @value = value.to_f
    end

    def to_s
      @value.round(9).to_s
    end

    def exp(n)
      @value **= n.value
      return self
    end

    def sqrt(n)
      @value = n.value**(1/@value)
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
