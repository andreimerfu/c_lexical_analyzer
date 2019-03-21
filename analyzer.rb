require_relative "dfa"

class Analyzer
  attr_accessor :dfa, :strings_list

  TOKEN_TYPE = {
    identifier: 0,
    keyword: 1,
    string: 2,
    char: 3,
    float: 4,
    hexadecimal: 5,
    comment: 6,
    whitespace: 7,
    operator: 8,
    separator: 9,
    error: 10,
    invalid_token: 11
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
    r = dfa.execute
    final_state = r.first
    token_value = r.last

    if (final_state == Dfa::STATE[:error])
      puts "EROARE  - " + token_value.to_s + " POZITIA - " + dfa.get_position.to_s
      return
    end

    token_type = ""

    if (KEYWORDS.include? token_value)
      token_type = KEYWORD
    else
      token_type = get_token_type(final_state)
    end

    return if token_type == "INVALID_TOKEN"
    return get_token() if token_type == "COMMENT"
    return get_token() if token_type == "WHITESPACE"

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
    when Dfa::STATE[:multi_line_comment_end]
    when Dfa::STATE[:single_line_comment]
      return "COMMENT"
    when Dfa::STATE[:non_token_separator]
      return "WHITESPACE"
    when Dfa::STATE[:number]
    when Dfa::STATE[:number_u]
    when Dfa::STATE[:number_l]
    when Dfa::STATE[:number_ul]
    when Dfa::STATE[:zero]
      return "INTEGER"
    when Dfa::STATE[:hexa]
      return "HEXADECIMAL"
    when Dfa::STATE[:float_number]
    when Dfa::STATE[:exponent]
    when Dfa::STATE[:exponent_value]
    when Dfa::STATE[:float_number_l]
      return "FLOAT"
    when Dfa::STATE[:plus]
    when Dfa::STATE[:minus]
    when Dfa::STATE[:star]
    when Dfa::STATE[:slash]
    when Dfa::STATE[:mod]
    when Dfa::STATE[:equal]
    when Dfa::STATE[:less_than]
    when Dfa::STATE[:greater_than]
    when Dfa::STATE[:and]
    when Dfa::STATE[:not]
    when Dfa::STATE[:or]
    when Dfa::STATE[:xor]
    when Dfa::STATE[:shift_right]
    when Dfa::STATE[:shift_left]
    when Dfa::STATE[:point]
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
