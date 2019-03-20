class Token
  attr_accessor :type, :value

  def initialize(type, value)
    @type = type
    @value = value
  end

  def get_token_type(token_type)
    case token_type
    when Analyzer::IDENTIFIER
      return "IDENTIFICATOR"
    when Analyzer::KEYWORD
      return "CUVANT CHEIE"
    when Analyzer::STRING
      return "STRING"
    when Analyzer::INTEGER
      return "INTEGER"
    when Analyzer::FLOAT
      return "FLOAT"
    when Analyzer::HEXADEIMAL
      return "HEXADEIMAL"
    when Analyzer::COMMENT
      return "COMMENTARIU"
    when Analyzer::WHITESPACEC
      return "SPATIU"
    when Analyzer::OPERATOR
      return "OPERATOR"
    when Analyzer::SEPARATOR
      return "SEPARATOR"
    when Analyzer::ERROR
      return "EROARE"
    when Analyzer::INVALID_TOKEN
    else
      return "TOKEN_GRESIT"
    end
  end

  def get_string(lexical_analyzer)
    get_token_type(type) + " - " + lexical_analyzer.get_value(type)
  end
end
