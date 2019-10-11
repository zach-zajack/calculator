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
    end

    def sqrt(n)
      @value = n.value**(1/@value)
    end

    def log(n)
      @value = Math.log(n.value, @value)
    end

    def multiply(n)
      @value *= n.value
    end

    def divide(n)
      @value /= n.value
    end

    def add(n)
      @value += n.value
    end

    def subtract(n)
      @value -= n.value
    end
  end
end
