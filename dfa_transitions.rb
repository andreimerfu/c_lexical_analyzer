require_relative "dfa_state"

STATE = DFA_STATE

def dfa_transitions
  initial_list = []

  transitions = {}
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
  transitions[STATE[:char]] = char_list

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
  number_list.push([method(:is_e).to_proc, STATE[:exponent_value]])
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
  exponent_list.push([method(:anything).to_proc, STATE[:error]])
  transitions[STATE[:exponent]] = exponent_list

  ev_list = []
  ev_list.push([method(:is_digit).to_proc, STATE[:exponent_value]])
  ev_list.push([method(:anything).to_proc, STATE[:end]])
  transitions[STATE[:exponent_value]] = ev_list

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

  transitions
end
