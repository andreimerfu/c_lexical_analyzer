require_relative "dfa"

class Analyzer
  attr_accessor :dfa, :strings_list

  TOKEN_TYPE = {
    identifier: 0,
    keyword: 1,
    string: 2,
    char: 3,
    integer: 4,
    float: 5,
    hexadecimal: 6,
    comment: 7,
    whitespace: 8,
    operator: 9,
    separator: 10,
    error: 11,
    invalid_token: 12
  }.freeze

  KEYWORDS = [
    "auto", "int", "const", "short", "break", "long", "continue", "signed",
    "double", "struct", "float", "unsigned", "else", "switch", "for",
    "void", "case", "register", "default", "sizeof", "char", "return", "do",
    "static", "enum", "typedef", "goto", "volatile", "extern", "union", "if", "while"
  ].freeze

  def initialize(file_path)
    @dfa = Dfa.new(file_path)
    @strings_list = []
  end

  def get_token
    if dfa.is_EOF
      return
    end

    r = dfa.execute
    final_state = r.first
    token_value = r.last

    if (final_state == Dfa::STATE[:error])
      puts "EROARE  - " + token_value.to_s + " POZITIA - " + dfa.get_position.to_s
      return
    end

    token_type = ""

    if (KEYWORDS.include? token_value)
      token_type = TOKEN_TYPE.key(1)
    else
      token_type = get_token_type(final_state)
    end

    return if token_type == "INVALID_TOKEN"
    return get_token if token_type == "COMMENT"
    return get_token if token_type == "WHITESPACE"

    string_list_index = 0
    if (strings_list.include? token_value)
      string_list_index = strings_list.index(token_value)
    else
      strings_list.push(token_value)
      string_list_index = strings_list.length - 1
    end

    return Token.new(token_type, string_list_index)
  end

  def get_token_type(final_state)
    case final_state
    when Dfa::STATE[:string_end]
      return "STRING"
    when Dfa::STATE[:char_end]
      return "CHAR"
    when Dfa::STATE[:multi_line_comment_end],
      Dfa::STATE[:single_line_comment]
      return "COMMENT"
    when Dfa::STATE[:non_token_separator]
      return "WHITESPACE"
    when Dfa::STATE[:number],
      Dfa::STATE[:number_u],
      Dfa::STATE[:number_l],
      Dfa::STATE[:number_ul],
      Dfa::STATE[:zero]
      return "INTEGER"
    when Dfa::STATE[:hexa]
      return "HEXADECIMAL"
    when Dfa::STATE[:float_number],
      Dfa::STATE[:exponent],
      Dfa::STATE[:exponent_value],
      Dfa::STATE[:float_number_l]
      return "FLOAT"
    when Dfa::STATE[:plus],
      Dfa::STATE[:minus],
      Dfa::STATE[:star],
      Dfa::STATE[:slash],
      Dfa::STATE[:mod],
      Dfa::STATE[:equal],
      Dfa::STATE[:less_than],
      Dfa::STATE[:greater_than],
      Dfa::STATE[:and],
      Dfa::STATE[:not],
      Dfa::STATE[:or],
      Dfa::STATE[:xor],
      Dfa::STATE[:shift_right],
      Dfa::STATE[:shift_left],
      Dfa::STATE[:point],
      Dfa::STATE[:operator]
      return "OPERATOR"
    when Dfa::STATE[:separator]
      return "SEPARATOR"
    when Dfa::STATE[:identifier]
      return "IDENTIFIER"
    else
      return "INVALID_TOKEN"
    end
  end

  def get_value(i)
    return strings_list[i]
  end
end
