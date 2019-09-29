module Calculator
  class Parser < Lexer
    Instruction = Struct.new(:type, :args)
    INSTRUCTIONS = {
      exp: 2,
      sqrt: 1,
      nthrt: 2,
      multiply: 2,
      divide: 2,
      add: 2,
      subtract: 2
    }

    def run
      advance
      parse_expr until @token.type == :end_of_file
      compile
    end

    private

    def accept(token)
      accepted_token = @token
      return unless accepted_token.type == token
      advance
      return accepted_token
    end

    def advance
      while read_token == :whitespace
      end
    end

    def parse(*instructions)
      instructions.each do |token_instruction|
        next unless accept(token_instruction)
        yield
        @instructions << Instruction.new(token_instruction)
      end
    end

    def parse_expr
      parse_term
      parse(:add, :subtract) { parse_expr }
    end

    def parse_term
      parse_factor
      parse(:multiply, :divide, :exp, :sqrt, :nthrt) { parse_term }
    end

    def parse_factor
      if accept(:l_paren)
        parse_expr
        accept(:r_paren)
    # elsif name = accept(:name)
    #   @instructions << Instruction.new(name.value.to_sym)
    #   expect(:l_paren)
      elsif num = accept(:number)
        @instructions << Instruction.new(:push, [Number.new(num.value)])
      end
    end

    def compile
      @stack = []
      while instruction = @instructions.shift
        INSTRUCTIONS.each do |name, args_count|
          break @stack.push(instruction.args.first) if instruction.type == :push
          next unless instruction.type == name
          num, *args = @stack.pop(args_count)
          break @stack.push(num.send(name, *args))
        end
      end
      `document.getElementById("answer").textContent = #{@stack.first}`
    end
  end
end
