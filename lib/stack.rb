module Calculator
  class Stack

    def initialize
      @stack = []
    end

    def push(value)
      @stack.push(Number.new(value))
    end

    def pop(number)
      @stack.pop(number)
    end

    def result
      "=#{@stack[0]}" if @stack.length == 1
    end
  end
end
