module Calculator
  class Lexer
    Token = Struct.new(:type, :value)
    TOKENS = {
    # name: '[A-z]+\w*',
      number: '-?\d*\.?\d+',
    # whitespace: '\s',
      l_paren: '\(',
      r_paren: '\)',
      exp: '\^',
      sqrt: 'sqrt',
      nthrt: 'nthrt',
      multiply: '\*',
      divide: '\/',
      add: '\+',
      subtract: '-',
      nil: nil
    }

    def initialize(source)
      @source = simplify_latex(source)
      @pos = 0
      @instructions = []
      clear_token
    end

    private

    def simplify_latex(source)
      # gsub! doesn't work in Opal
      source
        .gsub('\left(', "(")
        .gsub('\right)', ")")
        .gsub(/\^\{(.*?)\}/, '^(\1)')
        .gsub(/\\sqrt\{(.*?)\}/, 'sqrt(\1)')
        .gsub(/\\sqrt\[(.*?)\]\{(.*?)\}/, '\1nthrt(\2)')
        .gsub('\cdot', "*")
        .gsub(/\\frac\{(.*?)\}\{(.*?)\}/, '((\1)/(\2))')
        .gsub(/(#{TOKENS[:number]})\((.*?)\)/, '\1*\2')
    end

    def clear_token
      @token = Token.new(nil, "")
    end

    def read_token
      clear_token
      TOKENS.each do |name, pattern|
        return @token.type = :end_of_file if stream == "" || name == :nil
        next unless value = /^#{pattern}/.match(stream)
        @token.value = value[0]
        @token.type = name
        @pos += value[0].length
        return @token.type
      end
    end

    def stream
      @source[@pos..-1]
    end
  end
end
