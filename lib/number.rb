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

    def sin
      @value = Math.sin(@value)
    end

    def cos
      @value = Math.cos(@value)
    end

    def tan
      @value = Math.tan(@value)
    end

    def asin
      @value = Math.asin(@value)
    end

    def acos
      @value = Math.acos(@value)
    end

    def atan
      @value = Math.atan(@value)
    end

    def sinh
      @value = Math.sinh(@value)
    end

    def cosh
      @value = Math.cosh(@value)
    end

    def tanh
      @value = Math.tanh(@value)
    end

    def asinh
      @value = Math.asinh(@value)
    end

    def acosh
      @value = Math.acosh(@value)
    end

    def atanh
      @value = Math.atanh(@value)
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
  end
end
