module Calculator
  class Parser < Lexer
    Instruction = Struct.new(:type, :value)
    INSTRUCTIONS = {
      exp: 2,
      sqrt: 2,
      log: 2,
      multiply: 2,
      divide: 2,
      add: 2
    }
    CONSTS = {
      pi: Math::PI,
      tau: Math::PI*2,
      e: Math::E
    }

    def run
      next_token
      parse_expr until @token.type == :end
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
      parse_infix_operators(:add) { parse_expr }
    end

    def parse_term
      parse_factor
      parse_functions(:divide, :sqrt, :log) { parse_factor }
      parse_infix_operators(:multiply, :exp) { parse_term }
    end

    def parse_factor
      parse_bracket(:l_paren, :r_paren)
      parse_bracket(:l_bracket, :r_bracket)
      parse_bracket(:l_brace, :r_brace)
      if num = accept(:number)
        @instructions << Instruction.new(:push, num.value)
      elsif varname = accept(:name)
        @instructions << Instruction.new(:load, varname.value.sub("&", ""))
      end
    end

    def compile
      stack = Stack.new
      p @instructions.map { |i| "#{i.type} #{i.value}" } # debug; remove later
      while instr = @instructions.shift
        INSTRUCTIONS.each do |name, args_count|
          break stack.push(instr.value) if instr.type == :push
          if instr.type == :load
            const = CONSTS[instr.value]
            return "=?" if const.nil?
            break stack.push(const)
          end
          next unless instr.type == name
          num, *args = stack.pop(args_count)
          break stack.push(num.send(name, *args))
        end
      end
      return stack.result
    end
  end
end
