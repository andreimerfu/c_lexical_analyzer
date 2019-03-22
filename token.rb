class Token
  attr_accessor :type, :value

  def initialize(type, value)
    @type = type
    @value = value
  end

  def get_token_type(token_type)
    case token_type&.downcase&.to_sym
    when Analyzer::TOKEN_TYPE.key(0)
      return "IDENTIFICATOR"
    when Analyzer::TOKEN_TYPE.key(1)
      return "CUVANT CHEIE"
    when Analyzer::TOKEN_TYPE.key(2)
      return "STRING"
    when Analyzer::TOKEN_TYPE.key(3)
      return "CHAR"
    when Analyzer::TOKEN_TYPE.key(4)
      return "INTEGER"
    when Analyzer::TOKEN_TYPE.key(5)
      return "FLOAT"
    when Analyzer::TOKEN_TYPE.key(6)
      return "HEXADECIMAL"
    when Analyzer::TOKEN_TYPE.key(7)
      return "COMMENTARIU"
    when Analyzer::TOKEN_TYPE.key(8)
      return "SPATIU"
    when Analyzer::TOKEN_TYPE.key(9)
      return "OPERATOR"
    when Analyzer::TOKEN_TYPE.key(10)
      return "SEPARATOR"
    when Analyzer::TOKEN_TYPE.key(11)
      return "EROARE"
    when Analyzer::TOKEN_TYPE.key(12)
    else
      return "TOKEN_GRESIT"
    end
  end

  def get_string(lexical_analyzer)
    get_token_type(type) + " - " + lexical_analyzer.get_value(value)
  end
end
