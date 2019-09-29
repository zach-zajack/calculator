module Calculator
  class Parser < Lexer
    Instruction = Struct.new(:type, :args)
    InstructionType = Struct.new(:name, :args_count, :method)
    INSTRUCTIONS = [
      InstructionType.new(:exp, 2, :**),
      InstructionType.new(:multiply, 2, :*),
      InstructionType.new(:divide, 2, :/),
      InstructionType.new(:add, 2, :+),
      InstructionType.new(:subtract, 2, :-)
    ]

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
      parse(:multiply, :divide, :exp) { parse_term }
    end

    def parse_factor
      if accept(:l_paren)
        parse_expr
        accept(:r_paren)
    # elsif name = accept(:name)
    #   @instructions << Instruction.new(name.value.to_sym)
    #   expect(:l_paren)
      elsif num = accept(:number)
        @instructions << Instruction.new(:push, [num.value.to_f])
      end
    end

    def compile
      @stack = []
      while instruction = @instructions.shift
        INSTRUCTIONS.each do |instr_type|
          break @stack.push(instruction.args.first) if instruction.type == :push
          next unless instruction.type == instr_type.name
          num, *args = @stack.pop(instr_type.args_count)
          break @stack.push(num.send(instr_type.method, *args))
        end
      end
      `document.getElementById("answer").textContent = #{@stack.first}`
    end
  end
end
