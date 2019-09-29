module Calculator
  class Number
    def initialize(value)
      @r = Rational(value)
    end

    def to_s
      simplify
      str = @r.to_s
      str.end_with?("/1") ? str[0..-3] : str
    end

    def simplify
      gcd = @r.numerator.gcd(@r.denominator)
      @r = Rational(@r.numerator / gcd, @r.denominator / gcd)
    end

    def method_missing(name, *args, &block)
      output = @r.send(name, *args, &block)
      output.is_a?(Rational) ? Number.new(output) : output
    end
  end
end
