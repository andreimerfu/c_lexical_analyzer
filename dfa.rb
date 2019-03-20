class Dfa
  attr_accessor :fp, :file_position, :is_zero, :is_minus, :is_plus,
    :is_star

  STATE = {
    initial: 0,
    plus: 1,
    minus: 2,
    star: 3,
    slash: 4,
    mod: 5,
    equal: 6,
    less_than: 7,
    greater_than: 8,
    and: 9,
    not: 10,
    or: 11,
    xor: 12,
    shift_right: 13,
    shift_left: 14,
    point: 15,
    non_token_separator: 16,
    separator: 17,
    comment: 18,
    single_line_comment: 19,
    multi_line_comment: 20,
    multi_line_comment_star: 21,
    multi_line_comment_end: 22,
    char: 23,
    char_escape: 24,
    char_escape_x: 25,
    char_escape_hex1: 26,
    char_escape_number: 27,
    char_character: 28,
    char_end: 29,
    string: 30,
    string_escape: 31,
    string_end: 32,
    number: 33,
    number_u: 34,
    number_l: 35,
    number_ul: 36,
    zero: 37,
    hexa: 38,
    float_number: 39,
    exponent: 40,
    exponent_value: 41,
    float_number_l: 42,
    operator: 43,
    end: 44,
    error: 45
  }.freeze

  is_zero      = lambda { |value| return value == '0' }
  is_plus      = lambda { |value| return value == '+' }
  is_minus     = lambda { |value| return value == '-' }
  is_star      = lambda { |value| return value == '*' }
  is_slash     = lambda { |value| return value == '/' }
  is_mod       = lambda { |value| return value == '%' }
  is_equal     = lambda { |value| return value == '=' }
  is_less      = lambda { |value| return value == '<' }
  is_greater   = lambda { |value| return value == '>' }
  is_and       = lambda { |value| return value == '&' }
  # def is_plus(c)
  #   return c == '+'
  # end

  # def is_minus(c)
  #   return c == '-'
  # end

  # def is_star(c)
  #   return c == '*'
  # end

  # def is_slash(c)
  #   return c == '/'
  # end

  # def is_mod(c)
  #   return c == '%'
  # end

  # def is_equal(c)
  #   return c == '='
  # end

  # def is_less(c)
  #   return c == '<'
  # end

  # def is_greater(c)
  #   return c == '>'
  # end

  def is_and(c)
    return c == '&'
  end

  def is_not(c)
    return c == '!'
  end

  def is_or(c)
    return c == '|'
  end

  def is_xor(c)
    return c == '^'
  end

  def is_point(c)
    return c == '.'
  end

  def is_separator(c)
    case c
    when ';'
    when ','
    when '{'
    when '}'
    when ']'
    when '['
    when ')'
    when '('
      return true
    else
      return false
    end
  end

  def is_operator?(c)
    case c
    when ':'
    when '?'
      return true
    else
      return false
    end
  end

  def is_non_token(c)
    case c
    when '\n'
    when '\t'
    when ' '
      return true
    else
      return false
    end
  end

  def is_single_quote(c)
    return c == "\'"
  end

  def is_double_quote(c)
    return c == '\"'
  end

  def is_e(c)
    return c == 'e'
  end

  def is_char(c)
    return c >= 32 && c <= 126
  end

  def is_digit(c)
    return c >= '0' && c <= '9'
  end

  def is_hexa(c)
    return is_digit(c) || ('a' <= c && c <= 'f')
  end

  def is_escape(c)
    return c == '\\'
  end

  def is_new_line(c)
    return c == '\n'
  end

  def anything?(c)
    true
  end

  def is_letter(c)
    return ('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z')
  end

  def is_first_char_for_id(c)
    return is_letter(c) || c == '_'
  end

  def is_char_for_id(c)
    return is_first_char_for_id(c) || is_digit(c)
  end

  def is_not_char_for_id(c)
    return !is_char_for_id(c)
  end

  def is_x(c)
    return c == 'x'
  end

  def is_l(c)
    return c == 'l'
  end

  def is_u(c)
    return c == 'u'
  end

  def initialize(file_name)
    transitions = {}

    initial_list = []
    initial_list.push([is_zero, STATE[:zero]])
    initial_list.push([is_plus, STATE[:plus]])
    initial_list.push([is_minus, STATE[:minus]])
    initial_list.push([is_star, STATE[:star]])
    initial_list.push([is_slash, SLASH])
    initial_list.push([is_mod, MOD])
    initial_list.push([is_equal, EQUAL])
    initial_list.push([is_less, LESS_THAN])
    initial_list.push([is_greater, GREATER_THAN])
    initial_list.push([is_and, AND])
    initial_list.push([is_not, NOT])
    initial_list.push([is_or, OR])
    initial_list.push([is_xor, XOR])
    initial_list.push([is_point, POINT])
    initial_list.push([is_separator, SEPARATOR])
    initial_list.push([is_operator, OPERATOR])
    initial_list.push([is_non_token, NON_TOKEN_SEPARATOR])
    initial_list.push([is_first_char_for_id, IDENTIFIER])
    initial_list.push([is_digit, NUMBER])
    initial_list.push([is_single_quote, CHAR])
    initial_list.push([is_double_quote, STRING])
    initial_list.push([anything, ERROR])
    transitions[INITIAL] = initial_list

    identifier_list = []
    identifier_list.push([is_char_for_id, IDENTIFIER])
    identifier_list.push([is_not_char_for_id, STATE[:end]])
    transitions[IDENTIFIER] = identifier_list

    plus_list = []
    plus_list.push([is_plus, PLUS])
    plus_list.push([is_plus, OPERATOR])
    plus_list.push([is_equal, PLUS])
    plus_list.push([is_equal, OPERATOR])
    plus_list.push([anything, STATE[:end]])
    transitions[PLUS] = plus_list

    minus_list = []
    minus_list.push([is_minus, MINUS])
    minus_list.push([is_minus, OPERATOR])
    minus_list.push([is_greater, OPERATOR])
    minus_list.push([is_equal, OPERATOR])
    minus_list.push([is_digit, NUMBER])
    minus_list.push([anything, STATE[:end]])
    transitions[MINUS] = minus_list

    star_list = []
    star_list.push([is_equal, OPERATOR])
    star_list.push([anything, STATE[:end]])
    transitions[STAR] = star_list

    slash_list = []
    slash_list.push([is_equal, OPERATOR])
    slash_list.push([is_slash, SINGLE_LINE_COMMENT])
    slash_list.push([is_star, MULTI_LINE_COMMENT])
    slash_list.push([anything, STATE[:end]])
    transitions[SLASH] = slash_list

    mod_list = []
    mod_list.push([is_equal, OPERATOR])
    mod_list.push([anything, STATE[:end]])
    transitions[MOD] = mod_list

    equal_list = []
    equal_list.push([is_equal, EQUAL])
    equal_list.push([is_equal, OPERATOR])
    equal_list.push([anything, STATE[:end]])
    transitions[EQUAL] = equal_list

    less_than_list = []
    less_than_list.push([is_equal, OPERATOR])
    less_than_list.push([is_less, SHIFT_LEFT])
    less_than_list.push([anything, STATE[:end]])
    transitions[LESS_THAN] = less_than_list

    greater_than_list = []
    greater_than_list.push([is_equal, OPERATOR])
    greater_than_list.push([is_greater, SHIFT_LEFT])
    greater_than_list.push([anything, STATE[:end]])
    transitions[GREATER_THAN] = greater_than_list

    shift_left_list = []
    shift_left_list.push([is_less, SHIFT_LEFT])
    shift_left_list.push([is_equal, SHIFT_LEFT])
    shift_left_list.push([is_equal, OPERATOR])
    shift_left_list.push([anything, STATE[:end]])
    transitions[SHIFT_LEFT] = shift_left_list

    shift_right_list = []
    shift_right_list.push([is_greater, SHIFT_RIGHT])
    shift_right_list.push([is_equal, SHIFT_RIGHT])
    shift_right_list.push([is_equal, OPERATOR])
    shift_right_list.push([anything, STATE[:end]])
    transitions[SHIFT_RIGHT] = shift_right_list

    and_list = []
    and_list.push([is_and, AND])
    and_list.push([is_and, OPERATOR])
    and_list.push([is_equal, OPERATOR])
    and_list.push([anything, STATE[:end]])
    transitions[AND] = and_list

    or_list = []
    or_list.push([is_or, OPERATOR])
    or_list.push([is_equal, OPERATOR])
    or_list.push([anything, STATE[:end]])
    transitions[OR] = or_list

    not_list = []
    not_list.push([is_equal, OPERATOR])
    not_list.push([anything, STATE[:end]])
    transitions[NOT] = not_list

    xor_list = []
    xor_list.push([is_equal, OPERATOR])
    xor_list.push([anything, STATE[:end]])
    transitions[XOR] = xor_list

    point_list = []
    point_list.push([is_digit, FLOAT_NUMBER])
    point_list.push([is_char_for_id, STATE[:end]])
    point_list.push([anything, ERROR])
    transitions[POINT] = point_list

    sep_list = []
    sep_list.push([anything, STATE[:end]])
    transitions[SEPARATOR] = sep_list

    non_token_sep_list
    non_token_sep_list.push([is_non_token, NON_TOKEN_SEPARATOR])
    non_token_sep_list.push([anything, STATE[:end]])
    transitions[NON_TOKEN_SEPARATOR] = non_token_sep_list

    char_list = []
    char_list.push([is_escape, CHAR_ESCAPE])
    char_list.push([is_char, CHAR_CHARACTER])
    char_list.push([anything, ERROR])
    transitions[CHAR] = char_list

    char_character_list = []
    char_character_list.push([is_single_quote, CHAR_END])
    char_character_list.push([anything, ERROR])
    transitions[CHAR_CHARACTER] = char_character_list

    char_escape_list = []
    char_escape_list.push([is_digit, CHAR_ESCAPE_NUMBER])
    char_escape_list.push([is_char, CHAR_CHARACTER])
    char_escape_list.push([is_x, CHAR_ESCAPE_X])
    char_escape_list.push([is_char, CHAR_CHARACTER])
    char_escape_list.push([anything, ERROR])
    transitions[CHAR_ESCAPE] = char_escape_list

    char_escape_number_list = []
    char_escape_number_list.push([is_digit, CHAR_ESCAPE_NUMBER])
    char_escape_number_list.push([is_single_quote, CHAR_END])
    char_escape_number_list.push([anything, ERROR])
    transitions[CHAR_ESCAPE_NUMBER] = char_escape_number_list

    char_escape_x_list = []
    char_escape_x_list.push([is_hexa, CHAR_ESCAPE_HEX1])
    char_escape_x_list.push([anything, ERROR])
    transitions[CHAR_ESCAPE_X] = char_escape_x_list

    char_end_list = []
    char_end_list.push([anything, STATE[:end]])
    transitions[CHAR_END] = char_end_list

    string_list = []
    string_list.push([is_double_quote, STRING_END])
    string_list.push([is_escape, STRING_ESCAPE])
    string_list.push([is_char, STRING])
    string_list.push([anything, ERROR])
    transitions[STRING] = string_list

    string_escape_list = []
    string_escape_list.push([is_char, STRING])
    string_escape_list.push([is_new_line, STRING])
    string_escape_list.push([anything, ERROR])
    transitions[STRING_ESCAPE] = string_escape_list

    string_end_list = []
    string_end_list.push([anything, STATE[:end]])
    transitions[STRING_END] = string_end_list

    number_list = []
    number_list.push([is_digit, NUMBER])
    number_list.push([is_point, FLOAT_NUMBER])
    number_list.push([is_l, NUMBER_L])
    number_list.push([is_u, NUMBER_U])
    number_list.push([anything, STATE[:end]])
    transitions[NUMBER] = number_list

    number_list_l = []
    number_list_l.push([is_u, NUMBER_UL])
    number_list_l.push([anything, STATE[:end]])
    transitions[NUMBER_L] = number_list_l

    number_list_u = []
    number_list_u.push([is_l, NUMBER_UL])
    number_list_u.push([anything, STATE[:end]])
    transitions[NUMBER_UL] = number_list_u

    number_list_ul = []
    number_list_ul.push([anything, STATE[:end]])
    transitions[NUMBER_UL] = number_list_ul

    float_number_list = []
    float_number_list.push([is_digit, FLOAT_NUMBER])
    float_number_list.push([is_l, FLOAT_NUMBER_L])
    float_number_list.push([is_e, EXPONENT])
    float_number_list.push([anything, STATE[:end]])
    transitions[FLOAT_NUMBER] = float_number_list

    exponent_list = []
    exponent_list.push([is_minus, EXPONENT_VALUE])
    exponent_list.push([is_plus, EXPONENT_VALUE])
    exponent_list.push([is_digit, EXPONENT_VALUE])
    exponent_list.push([anything, ERROR]) # ERROR DACA ESTE EXPONENT
    transitions[EXPONENT] = exponent_list

    float_number_l_list = []
    float_number_l_list.push([anything, STATE[:end]])
    transitions[FLOAT_NUMBER_L] = float_number_l_list

    zero_list = []
    zero_list.push([is_x, HEXA])
    zero_list.push([is_digit, NUMBER])
    zero_list.push([anything, STATE[:end]])
    transitions[ZERO] = zero_list

    hexa_list = []
    hexa_list.push([is_hexa, HEXA])
    hexa_list.push([anything, STATE[:end]])
    transitions[HEXA] = hexa_list

    comment_list = []
    comment_list.push([is_slash, SINGLE_LINE_COMMENT])
    comment_list.push([is_star, MULTI_LINE_COMMENT])
    comment_list.push([anything, ERROR])
    transitions[COMMENT] = comment_list

    multi_line_comment_list = []
    multi_line_comment_list.push([is_star, MULTI_LINE_COMMENT_STAR])
    multi_line_comment_list.push([anything, MULTI_LINE_COMMENT])
    transitions[MULTI_LINE_COMMENT] = multi_line_comment_list

    multi_line_comment_star_list = []
    multi_line_comment_star_list.push([is_slash, MULTI_LINE_COMMENT_END])
    multi_line_comment_star_list.push([is_star, MULTI_LINE_COMMENT_STAR])
    multi_line_comment_star_list.push([anything, MULTI_LINE_COMMENT])
    transitions[MULTI_LINE_COMMENT_STAR] = multi_line_comment_star_list

    multi_line_comment_end_list = []
    multi_line_comment_end_list.push([anything, STATE[:end]])
    transitions[MULTI_LINE_COMMENT_STAR] = multi_line_comment_end_list

    single_line_comment_list = []
    single_line_comment_list.push([is_new_line, STATE[:end]])
    single_line_comment_list.push([anything, SINGLE_LINE_COMMENT])
    transitions[SINGLE_LINE_COMMENT] = single_line_comment_list

    operator_list = []
    operator_list.push([anything, STATE[:end]])
    transitions[OPERATOR] = operator_list

    @file_position = 0
  end

  def execute
    current_state = INITIAL

    File.open(file_name, "r") do |f|
      f.each_char do |c|
        file_position++
        state_transitions = transitions[current_state]

        state_transitions.each do |transition|
          transition_function = transition.first
          next_state = transition.second

          if (transition_function.call(c))
            if next_state == ERROR
              [ERROR, token_value]
            end

            if (next_state == STATE[:end])
              file_position--
              [current_state, token_value]
            end

            current_state = next_state
            token_value += c
            break
          end
        end
      end
    end

    state_transitions = transitions[current_state]

    state_transitions.each do |transition|
      next_state = transition.second
      if (next_state == STATE[:end])
        [current_state, token_value]
      end
    end

    [ERROR, token_value]
  end
end
