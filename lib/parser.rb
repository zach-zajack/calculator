module Calculator
  class Parser < Lexer
    Instruction = Struct.new(:type, :value)
    Arguments = Struct.new(:count, :type)
    INSTRUCTIONS = {
      exp: 2,
      sqrt: 2,
      multiply: 2,
      divide: 2,
      add: 2,
      subtract: 2
    }

    def run
      next_token
      parse_expr until @token.type == :end_of_file
      compile
    end

    private

    def accept(token)
      accepted_token = @token
      return unless accepted_token.type == token
      next_token
      return accepted_token
    end

    def parse_infix_operators(*instructions)
      instructions.each do |token_instruction|
        next unless accept(token_instruction)
        yield
        @instructions << Instruction.new(token_instruction)
      end
    end

    def parse_functions(*instructions)
      instructions.each do |token_instruction|
        next unless accept(token_instruction)
        INSTRUCTIONS[token_instruction].times { yield }
        @instructions << Instruction.new(token_instruction)
      end
    end

    def parse_bracket(left, right)
      if accept(left)
        parse_expr
        accept(right)
      end
    end

    def parse_expr
      parse_term
      parse_infix_operators(:add, :subtract) { parse_expr }
    end

    def parse_term
      parse_factor
      parse_functions(:divide, :sqrt) { parse_term }
      parse_infix_operators(:multiply, :exp) { parse_term }
    end

    def parse_factor
      parse_bracket(:l_paren, :r_paren)
      parse_bracket(:l_bracket, :r_bracket)
      parse_bracket(:l_brace, :r_brace)
      if num = accept(:number)
        @instructions << Instruction.new(:push, Number.new(num.value))
      end
    end

    def compile
      @stack = []
      p @instructions.map { |i| "#{i.type} #{i.value}" }
      while instr = @instructions.shift
        INSTRUCTIONS.each do |name, args_count|
          break @stack.push(instr.value) if instr.type == :push
          next unless instr.type == name
          num, *args = @stack.pop(args_count)
          break @stack.push(num.send(name, *args))
        end
      end
      `document.getElementById("answer").textContent = #{@stack.first}`
    end
  end
end
