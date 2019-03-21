require "pry"

class Dfa
  # attr_accessor :fp, :file_name, :is_minus, :is_plus,
  #   :is_star, :is_slash, :is_mod, :is_equal, :is_less, :is_greater, :is_and,
  #   :is_not, :is_or, :is_xor, :is_point, :is_separator, :is_operator, :is_non_token, :is_single_quote,
  #   :is_double_quote, :is_e, :is_hexa, :is_char, :is_digit, :is_escape, :anything,
  #   :is_letter, :is_first_char_for_id, :is_char_for_id, :is_not_char_for_id, :is_new_line,
  #   :is_x, :is_l, :is_u, :transitions

  attr_accessor :fp, :file_name, :transitions, :file_position

  STATE = {
    initial: 0,
    identifier: 1,
    plus: 2,
    minus: 3,
    star: 4,
    slash: 5,
    mod: 6,
    equal: 7,
    less_than: 8,
    greater_than: 9,
    and: 10,
    not: 11,
    or: 12,
    xor: 13,
    shift_right: 14,
    shift_left: 15,
    point: 16,
    non_token_separator: 17,
    separator: 18,
    comment: 19,
    single_line_comment: 20,
    multi_line_comment: 21,
    multi_line_comment_star: 22,
    multi_line_comment_end: 23,
    char: 24,
    char_escape: 25,
    char_escape_x: 26,
    char_escape_hex1: 27,
    char_escape_number: 28,
    char_character: 29,
    char_end: 30,
    string: 31,
    string_escape: 32,
    string_end: 33,
    number: 34,
    number_u: 35,
    number_l: 36,
    number_ul: 37,
    zero: 38,
    hexa: 39,
    float_number: 40,
    exponent: 41,
    exponent_value: 42,
    float_number_l: 43,
    operator: 44,
    end: 45,
    error: 46
  }.freeze

  def is_zero(value)
    return value == '0'
  end

  def is_plus(value)
    return value == '+'
  end

  def is_minus(value)
    value == '-'
  end

  def is_star(value)
    value == '*'
  end

  def is_slash(value)
    value == '/'
  end

  def is_mod(value)
    value == '%'
  end

  def is_equal(value)
    value == '='
  end

  def is_less(value)
    value == '<'
  end

  def is_greater(value)
    value == '>'
  end

  def is_and(value)
    value == '&'
  end

  def is_not(value)
    value == '!'
  end

  def is_or(value)
    value == '|'
  end

  def is_xor(value)
    value == '^'
  end

  def is_point(value)
    value == '.'
  end

  def is_separator(value)
    case value
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

  def is_operator(value)
    case value
    when ':'
    when '?'
      return true
    else
      return false
    end
  end

  def is_non_token(value)
    case value
    when '\n'
    when '\t'
    when ' '
      return true
    else
      return false
    end
  end


  # is_zero      = lambda { |value| return value == '0' }
  # is_plus      = lambda { |value| return value == '+' }
  # is_minus     = lambda { |value| return value == '-' }
  # is_star      = lambda { |value| return value == '*' }
  # is_slash     = lambda { |value| return value == '/' }
  # is_mod       = lambda { |value| return value == '%' }
  # is_equal     = lambda { |value| return value == '=' }
  # is_less      = lambda { |value| return value == '<' }
  # is_greater   = lambda { |value| return value == '>' }
  # is_and       = lambda { |value| return value == '&' }
  # is_not       = lambda { |value| return value == '!' }
  # is_or        = lambda { |value| return value == '|' }
  # is_xor       = lambda { |value| return value == '^' }
  # is_point     = lambda { |value| return value == '.' }

  # is_separator = lambda do |value|
  #   case value
  #   when ';'
  #   when ','
  #   when '{'
  #   when '}'
  #   when ']'
  #   when '['
  #   when ')'
  #   when '('
  #     return true
  #   else
  #     return false
  #   end
  # end

  # is_operator = lambda do |value|
  #   case value
  #   when ':'
  #   when '?'
  #     return true
  #   else
  #     return false
  #   end
  # end

  # is_non_token = lambda do |value|
  #   case value
  #   when '\n'
  #   when '\t'
  #   when ' '
  #     return true
  #   else
  #     return false
  #   end
  # end

  # is_single_quote = lambda { |value| return value == "\'" }
  # is_double_quote = lambda { |value| return value == '\"' }
  # is_e            = lambda { |value| return value == 'e'  }
  # is_char         = lambda { |value| return value >= 32 && value <= 126 }
  # is_digit        = lambda { |value| return value >= '0' && value <= '9' }
  # is_hexa         = lambda { |v| return is_digit.call(v) || ('a' <= v && v <= 'f') }
  # is_escape       = lambda { |value| return value == '\\' }
  # is_new_line     = lambda { |value| return value == '\n' }
  # anything        = lambda { |value| return true }
  # is_letter       = lambda { |v| return ('a' <= v && v <= 'z') || ('A' <= v && v <= 'Z') }
  # is_first_char_for_id = lambda { |value| return is_letter.call(value) || value == '_' }
  # is_char_for_id  = lambda { |value| is_first_char_for_id.call(value) || is_digit.call(value) }
  # is_not_char_for_id = lambda { |value| !is_char_for_id.call(value) }
  # is_x            = lambda { |value| return value == 'x' }
  # is_l            = lambda { |value| return value == 'c' }
  # is_u            = lambda { |value| return value == 'u' }

  def is_single_quote(value)
    value == "\'"
  end

  def is_double_quote(value)
    value == '\"'
  end

  def is_e(value)
    value == 'e'
  end

  def is_char(value)
    value >= 32 && value <= 126
  end

  def is_digit(value)
    value >= '0' && value <= '9'
  end

  def is_hexa(value)
    is_digit(value) || ('a' <= value && value <= 'f')
  end

  def is_escape(value)
    value == '\\'
  end

  def is_new_line(value)
    value == '\n'
  end

  def anything(value)
    true
  end

  def is_letter(value)
    ('a' <= value && value <= 'z') || ('A' <= value && v <= 'Z')
  end

  def is_first_char_for_id(value)
    is_letter(value) || value == '_'
  end

  def is_char_for_id(value)
    is_first_char_for_id(value) || is_digit(value)
  end

  def is_not_char_for_id(value)
    !is_char_for_id(value)
  end

  def is_x(value)
    value == 'x'
  end

  def is_u(value)
    value == 'u'
  end

  def is_c(value)
    value == 'c'
  end

  def is_l(value)
    value == 'l'
  end

  def initialize(file_name)
    @file_name = file_name
    @transitions = {}
    initial_list = []
    initial_list.push([method(:is_zero).to_proc, STATE[:zero]])
    initial_list.push([method(:is_plus).to_proc, STATE[:plus]])
    initial_list.push([method(:is_minus).to_proc, STATE[:minus]])
    initial_list.push([method(:is_star).to_proc, STATE[:star]])
    initial_list.push([method(:is_slash).to_proc, STATE[:slash]])
    initial_list.push([method(:is_mod).to_proc, STATE[:mod]])
    initial_list.push([method(:is_equal).to_proc, STATE[:equal]])
    initial_list.push([method(:is_less).to_proc, STATE[:less_than]])
    initial_list.push([method(:is_greater).to_proc, STATE[:greater_than]])
    initial_list.push([method(:is_and).to_proc, STATE[:and]])
    initial_list.push([method(:is_not).to_proc, STATE[:not]])
    initial_list.push([method(:is_or).to_proc, STATE[:or]])
    initial_list.push([method(:is_xor).to_proc, STATE[:xor]])
    initial_list.push([method(:is_point).to_proc, STATE[:point]])
    initial_list.push([method(:is_separator).to_proc, STATE[:separator]])
    initial_list.push([method(:is_operator).to_proc, STATE[:operator]])
    initial_list.push([method(:is_non_token).to_proc, STATE[:non_token_separator]])
    initial_list.push([method(:is_first_char_for_id).to_proc, STATE[:identifier]])
    initial_list.push([method(:is_digit).to_proc, STATE[:number]])
    initial_list.push([method(:is_single_quote).to_proc, STATE[:char]])
    initial_list.push([method(:is_double_quote).to_proc, STATE[:string]])
    initial_list.push([method(:anything).to_proc, STATE[:error]])
    transitions[STATE[:initial]] = initial_list

    identifier_list = []
    identifier_list.push([method(:is_char_for_id).to_proc, STATE[:identifier]])
    identifier_list.push([method(:is_not_char_for_id).to_proc, STATE[:end]])
    transitions[STATE[:identifier]] = identifier_list

    plus_list = []
    plus_list.push([method(:is_plus).to_proc, STATE[:plus]])
    plus_list.push([method(:is_plus).to_proc, STATE[:operator]])
    plus_list.push([method(:is_equal).to_proc, STATE[:plus]])
    plus_list.push([method(:is_equal).to_proc, STATE[:operator]])
    plus_list.push([method(:anything).to_proc, STATE[:end]])
    transitions[STATE[:plus]] = plus_list

    minus_list = []
    minus_list.push([method(:is_minus).to_proc, STATE[:minus]])
    minus_list.push([method(:is_minus).to_proc, STATE[:operator]])
    minus_list.push([method(:is_greater).to_proc, STATE[:operator]])
    minus_list.push([method(:is_equal).to_proc, STATE[:operator]])
    minus_list.push([method(:is_digit).to_proc, STATE[:number]])
    minus_list.push([method(:anything).to_proc, STATE[:end]])
    transitions[STATE[:minus]] = minus_list

    star_list = []
    star_list.push([method(:is_equal).to_proc, STATE[:operator]])
    star_list.push([method(:anything).to_proc, STATE[:end]])
    transitions[STATE[:star]] = star_list

    slash_list = []
    slash_list.push([method(:is_equal).to_proc, STATE[:operator]])
    slash_list.push([method(:is_slash).to_proc, STATE[:single_line_comment]])
    slash_list.push([method(:is_star).to_proc, STATE[:multi_line_comment]])
    slash_list.push([method(:anything).to_proc, STATE[:end]])
    transitions[STATE[:slash]] = slash_list

    mod_list = []
    mod_list.push([method(:is_equal).to_proc, STATE[:operator]])
    mod_list.push([method(:anything).to_proc, STATE[:end]])
    transitions[STATE[:mod]] = mod_list

    equal_list = []
    equal_list.push([method(:is_equal).to_proc, STATE[:equal]])
    equal_list.push([method(:is_equal).to_proc, STATE[:operator]])
    equal_list.push([method(:anything).to_proc, STATE[:end]])
    transitions[STATE[:equal]] = equal_list

    less_than_list = []
    less_than_list.push([method(:is_equal).to_proc, STATE[:operator]])
    less_than_list.push([method(:is_less).to_proc, STATE[:shift_left]])
    less_than_list.push([method(:anything).to_proc, STATE[:end]])
    transitions[STATE[:less_than]] = less_than_list

    greater_than_list = []
    greater_than_list.push([method(:is_equal).to_proc, STATE[:operator]])
    greater_than_list.push([method(:is_greater).to_proc, STATE[:shift_left]])
    greater_than_list.push([method(:anything).to_proc, STATE[:end]])
    transitions[STATE[:greater_than]] = greater_than_list

    shift_left_list = []
    shift_left_list.push([method(:is_less).to_proc, STATE[:shift_left]])
    shift_left_list.push([method(:is_equal).to_proc, STATE[:shift_left]])
    shift_left_list.push([method(:is_equal).to_proc, STATE[:operator]])
    shift_left_list.push([method(:anything).to_proc, STATE[:end]])
    transitions[STATE[:shift_left]] = shift_left_list

    shift_right_list = []
    shift_right_list.push([method(:is_greater).to_proc, STATE[:shift_right]])
    shift_right_list.push([method(:is_equal).to_proc, STATE[:shift_right]])
    shift_right_list.push([method(:is_equal).to_proc, STATE[:operator]])
    shift_right_list.push([method(:anything).to_proc, STATE[:end]])
    transitions[STATE[:shift_right]] = shift_right_list

    and_list = []
    and_list.push([method(:is_and).to_proc, STATE[:and]])
    and_list.push([method(:is_and).to_proc, STATE[:operator]])
    and_list.push([method(:is_equal).to_proc, STATE[:operator]])
    and_list.push([method(:anything).to_proc, STATE[:end]])
    transitions[STATE[:and]] = and_list

    or_list = []
    or_list.push([method(:is_or).to_proc, STATE[:operator]])
    or_list.push([method(:is_equal).to_proc, STATE[:operator]])
    or_list.push([method(:anything).to_proc, STATE[:end]])
    transitions[STATE[:or]] = or_list

    not_list = []
    not_list.push([method(:is_equal).to_proc, STATE[:operator]])
    not_list.push([method(:anything).to_proc, STATE[:end]])
    transitions[STATE[:not]] = not_list

    xor_list = []
    xor_list.push([method(:is_equal).to_proc, STATE[:xor]])
    xor_list.push([method(:anything).to_proc, STATE[:end]])
    transitions[STATE[:xor]] = xor_list

    point_list = []
    point_list.push([method(:is_digit).to_proc, STATE[:float_number]])
    point_list.push([method(:is_char_for_id).to_proc, STATE[:end]])
    point_list.push([method(:anything).to_proc, STATE[:error]])
    transitions[STATE[:point]] = point_list

    sep_list = []
    sep_list.push([method(:anything).to_proc, STATE[:end]])
    transitions[STATE[:separator]] = sep_list

    non_token_sep_list = []
    non_token_sep_list.push([method(:is_non_token).to_proc, STATE[:non_token_separator]])
    non_token_sep_list.push([method(:anything).to_proc, STATE[:end]])
    transitions[STATE[:non_token_separator]] = non_token_sep_list

    char_list = []
    char_list.push([method(:is_escape).to_proc, STATE[:char_escape]])
    char_list.push([method(:is_char).to_proc, STATE[:char_character]])
    char_list.push([method(:anything).to_proc, STATE[:error]])
    transitions[STATE[:char_escape]] = char_list

    char_character_list = []
    char_character_list.push([method(:is_single_quote).to_proc, STATE[:char_end]])
    char_character_list.push([method(:anything).to_proc, STATE[:error]])
    transitions[STATE[:char_character]] = char_character_list

    char_escape_list = []
    char_escape_list.push([method(:is_digit).to_proc, STATE[:char_escape_list]])
    char_escape_list.push([method(:is_char).to_proc, STATE[:char_character]])
    char_escape_list.push([method(:is_x).to_proc, STATE[:char_escape_x]])
    char_escape_list.push([method(:is_char).to_proc, STATE[:char_character]])
    char_escape_list.push([method(:anything).to_proc, STATE[:error]])
    transitions[STATE[:char_escape]] = char_escape_list

    char_escape_number_list = []
    char_escape_number_list.push([method(:is_digit).to_proc, STATE[:char_escape_number]])
    char_escape_number_list.push([method(:is_single_quote).to_proc, STATE[:char_end]])
    char_escape_number_list.push([method(:anything).to_proc, STATE[:error]])
    transitions[STATE[:char_escape_number]] = char_escape_number_list

    char_escape_x_list = []
    char_escape_x_list.push([method(:is_hexa).to_proc, STATE[:char_escape_hex1]])
    char_escape_x_list.push([method(:anything).to_proc, STATE[:error]])
    transitions[STATE[:char_escape_x]] = char_escape_x_list

    char_end_list = []
    char_end_list.push([method(:anything).to_proc, STATE[:end]])
    transitions[STATE[:char_end]] = char_end_list

    string_list = []
    string_list.push([method(:is_double_quote).to_proc, STATE[:string_end]])
    string_list.push([method(:is_escape).to_proc, STATE[:string_escape]])
    string_list.push([method(:is_char).to_proc, STATE[:string]])
    string_list.push([method(:anything).to_proc, STATE[:error]])
    transitions[STATE[:string]] = string_list

    string_escape_list = []
    string_escape_list.push([method(:is_char).to_proc, STATE[:string]])
    string_escape_list.push([method(:is_new_line).to_proc, STATE[:string]])
    string_escape_list.push([method(:anything).to_proc, STATE[:error]])
    transitions[STATE[:string_escape]] = string_escape_list

    string_end_list = []
    string_end_list.push([method(:anything).to_proc, STATE[:end]])
    transitions[STATE[:string_end]] = string_end_list

    number_list = []
    number_list.push([method(:is_digit).to_proc, STATE[:number]])
    number_list.push([method(:is_point).to_proc, STATE[:float_number]])
    number_list.push([method(:is_l).to_proc, STATE[:number_l]])
    number_list.push([method(:is_u).to_proc, STATE[:number_u]])
    number_list.push([method(:anything).to_proc, STATE[:end]])
    transitions[STATE[:number]] = number_list

    number_list_l = []
    number_list_l.push([method(:is_u).to_proc, STATE[:number_ul]])
    number_list_l.push([method(:anything).to_proc, STATE[:end]])
    transitions[STATE[:number_l]] = number_list_l

    number_list_u = []
    number_list_u.push([method(:is_l).to_proc, STATE[:number_ul]])
    number_list_u.push([method(:anything).to_proc, STATE[:end]])
    transitions[STATE[:number_u]] = number_list_u

    number_list_ul = []
    number_list_ul.push([method(:anything).to_proc, STATE[:end]])
    transitions[STATE[:number_ul]] = number_list_ul

    float_number_list = []
    float_number_list.push([method(:is_digit).to_proc, STATE[:float_number]])
    float_number_list.push([method(:is_l).to_proc, STATE[:float_number_l]])
    float_number_list.push([method(:is_e).to_proc, STATE[:exponent]])
    float_number_list.push([method(:anything).to_proc, STATE[:end]])
    transitions[STATE[:float_number]] = float_number_list

    exponent_list = []
    exponent_list.push([method(:is_minus).to_proc, STATE[:exponent_value]])
    exponent_list.push([method(:is_plus).to_proc, STATE[:exponent_value]])
    exponent_list.push([method(:is_digit).to_proc, STATE[:exponent_value]])
    exponent_list.push([method(:anything).to_proc, STATE[:error]]) # ERROR DACA ESTE EXPONENT
    transitions[STATE[:exponent]] = exponent_list

    float_number_l_list = []
    float_number_l_list.push([method(:anything).to_proc, STATE[:end]])
    transitions[STATE[:float_number_l]] = float_number_l_list

    zero_list = []
    zero_list.push([method(:is_x).to_proc, STATE[:hexa]])
    zero_list.push([method(:is_digit).to_proc, STATE[:number]])
    zero_list.push([method(:anything).to_proc, STATE[:end]])
    transitions[STATE[:zero]] = zero_list

    hexa_list = []
    hexa_list.push([method(:is_hexa).to_proc, STATE[:hexa]])
    hexa_list.push([method(:anything).to_proc, STATE[:end]])
    transitions[STATE[:hexa]] = hexa_list

    comment_list = []
    comment_list.push([method(:is_slash).to_proc, STATE[:single_line_comment]])
    comment_list.push([method(:is_star).to_proc, STATE[:multi_line_comment]])
    comment_list.push([method(:anything).to_proc, STATE[:error]])
    transitions[STATE[:comment]] = comment_list

    multi_line_comment_list = []
    multi_line_comment_list.push([method(:is_star).to_proc, STATE[:multi_line_comment_star]])
    multi_line_comment_list.push([method(:anything).to_proc, STATE[:multi_line_comment]])
    transitions[STATE[:multi_line_comment]] = multi_line_comment_list

    multi_line_comment_star_list = []
    multi_line_comment_star_list.push([method(:is_slash).to_proc, STATE[:multi_line_comment_end]])
    multi_line_comment_star_list.push([method(:is_star).to_proc, STATE[:multi_line_comment_star]])
    multi_line_comment_star_list.push([method(:anything).to_proc, STATE[:multi_line_comment]])
    transitions[STATE[:multi_line_comment_star]] = multi_line_comment_star_list

    multi_line_comment_end_list = []
    multi_line_comment_end_list.push([method(:anything).to_proc, STATE[:end]])
    transitions[STATE[:multi_line_comment_end]] = multi_line_comment_end_list

    single_line_comment_list = []
    single_line_comment_list.push([method(:is_new_line).to_proc, STATE[:end]])
    single_line_comment_list.push([method(:anything).to_proc, STATE[:single_line_comment]])
    transitions[STATE[:single_line_comment]] = single_line_comment_list

    operator_list = []
    operator_list.push([method(:anything).to_proc, STATE[:end]])
    transitions[STATE[:operator]] = operator_list

    @file_position = 0
  end

  def execute
    current_state = STATE[:initial]
    # file_position = 0
    token_value = ""

    File.open(file_name, "r") do |f|
      f.seek(@file_position, IO::SEEK_SET)
      f.each_char do |c|
        @file_position += 1
        state_transitions = transitions[current_state]

        state_transitions&.each do |transition|
          transition_function = transition.first
          next_state = transition.last

          if (transition_function.call(c))
            if next_state == STATE[:error]
              return [STATE[:error], token_value]
            end

            if (next_state == STATE[:end])
              @file_position -= 1
              return [current_state, token_value]
            end

            current_state = next_state
            token_value += c
            break
          end
        end
      end
    end

    state_transitions = transitions[current_state]

    state_transitions&.each do |transition|
      next_state = transition.last
      if (next_state == STATE[:end])
        [current_state, token_value]
      end
    end

    [STATE[:error], token_value]
  end

  def is_EOF
    !fp || fp.eof?
  end

  def get_position
    @file_position
  end
end
