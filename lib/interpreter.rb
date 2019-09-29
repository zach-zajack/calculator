module Calculator
  class Interpreter < Parser
    def run
      parse_program
      @stack = []
      while instruction = @instructions.shift
        INSTRUCTIONS.each do |instr_type|
          break @stack.push(instruction.args.first) if instruction.type == :push
          next unless instruction.type == instr_type.name
          num, *args = @stack.pop(instr_type.args_count)
          break @stack.push(num.send(instr_type.method, *args))
        end
      end
    end

    def answer
      @stack.first.to_s
    end
  end
end
