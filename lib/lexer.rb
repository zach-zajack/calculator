module Calculator
  class Lexer
    Token = Struct.new(:type, :value)
    TOKENS = {
      name: '([A-Z]|[a-z]|&pi|&tau)(_\w+)?',
      number: '\d*\.?\d+',
      l_paren: '#left\(',
      r_paren: '#right\)',
      l_bracket: '\[',
      r_bracket: '\]',
      l_brace: '\{',
      r_brace: '\}',
      exp: '\^',
      sqrt: '#sqrt',
      log: '#log',
      sinh: "#sinh",
      cosh: "#cosh",
      tanh: "#tanh",
      asinh: "#asinh",
      acosh: "#acosh",
      atanh: "#atanh",
      sin: "#sin",
      cos: "#cos",
      tan: "#tan",
      asin: "#asin",
      acos: "#acos",
      atan: "#atan",
      multiply: '#cdot',
      divide: '#frac',
      add: '\+',
      subtract: '-',
      unrecognized: nil
    }

    def initialize(source)
      @source = analyze_shorthand(source)
      @pos = 0
      tokenize
      factor = [:name, :number, :r_paren, :r_brace]
      index_between_tokens(factor, [:name, :sqrt, :l_paren]) do |i|
        @tokens.insert(i, Token.new(:multiply))
      end
      index_between_tokens(factor, [:subtract]) do |i|
        @tokens.insert(i, Token.new(:add))
      end
      @tokens.each.with_index do |token, i|
        next unless token.type == :subtract
        @tokens.delete_at(i)
        @tokens.insert(i, Token.new(:number, -1), Token.new(:multiply))
      end
      p @tokens.map(&:type)
      @instructions = []
      clear_token
    end

    private

    def analyze_shorthand(source)
      # gsub! doesn't work in Opal
      source
        .gsub("\\", "#") # just makes parsing easier so I don't have to escape \
        .gsub(" ", "")
        .gsub("#pi", "&pi")
        .gsub("#tau", "&tau")
        .gsub("#sqrt{", "#sqrt[2]{")
        .gsub(/#log_((?!{).)/, '#log_{\1}')
        .gsub(/#log(?!_)/, '#log_{10}')
        .gsub("#ln", "#log_{e}")
        .gsub("#log_", "#log")
    end

    def tokenize
      @tokens = []
      until stream == ""
        TOKENS.each do |name, pattern|
          return if pattern.nil?
          next unless value = /^#{pattern}/.match(stream)
          @tokens << Token.new(name, value[0])
          @pos += value[0].length
          break
        end
      end
      @tokens << Token.new(:end)
    end

    def index_between_tokens(first_token_set, second_token_set)
      rindex = @tokens.length # reverse to prevent inserts messing up index
      @tokens.clone.each_cons(2) do |prev, current|
        rindex -= 1
        next unless first_token_set.include?(prev.type)
        next unless second_token_set.include?(current.type)
        yield @tokens.length - rindex
      end
    end

    def clear_token
      @token = Token.new(nil, "")
    end

    def next_token
      @token = @tokens.shift
      return @token.type
    end

    def stream
      @source[@pos..-1]
    end
  end
end
