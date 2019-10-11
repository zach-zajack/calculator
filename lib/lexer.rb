module Calculator
  class Lexer
    Token = Struct.new(:type, :value)
    TOKENS = {
      name: '([A-Z]|[a-z])',
      number: '-?\d*\.?\d+',
      l_paren: '#left\(',
      r_paren: '#right\)',
      l_bracket: '\[',
      r_bracket: '\]',
      l_brace: '\{',
      r_brace: '\}',
      exp: '\^',
      sqrt: '#sqrt',
      log: '#log',
      multiply: '#cdot',
      divide: '#frac',
      add: '\+',
      subtract: '-',
      nil: nil
    }

    def initialize(source)
      @source = analyze_shorthand(source)
      @pos = 0
      @instructions = []
      clear_token
    end

    private

    def analyze_shorthand(source)
      factor = "#{TOKENS[:number]}|#{TOKENS[:r_paren]}|#{TOKENS[:r_brace]}"
      # gsub! doesn't work in Opal
      source
        .gsub("\\", "#") # just makes parsing easier so I don't have to escape \
        .gsub(" ", "")
        .gsub("#sqrt{", "#sqrt[2]{")
        .gsub(/(#{factor})(#{TOKENS[:name]})/, '\1#cdot\2')
        .gsub(/(#{factor})(#{TOKENS[:sqrt]})/, '\1#cdot\2')
        .gsub(/(#{factor})(#{TOKENS[:l_paren]})/, '\1#cdot\2')
        .gsub(/(#{factor})(#{TOKENS[:subtract]})/, '\1+\2')
        .gsub(/#log_((?!{).)/, '#log_{\1}')
        .gsub(/#log(?!_)/, '#log_{10}')
        .gsub("#ln", "#log_{e}")
        .gsub("#log_", "#log")
        .gsub("-", "-1#cdot")
    end

    def clear_token
      @token = Token.new(nil, "")
    end

    def next_token
      clear_token
      TOKENS.each do |name, pattern|
        return @token.type = :end_of_file if stream == "" || name == :nil
        p stream
        next unless value = /^#{pattern}/.match(stream)
        @token.value = value[0]
        p @token.type = name
        @pos += value[0].length
        return @token.type
      end
    end

    def stream
      @source[@pos..-1]
    end
  end
end
