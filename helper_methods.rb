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
  when ";",
    ",",
    "{",
    "}",
    "]",
    "[",
    ")",
    "("
    return true
  else
    return false
  end
end

def is_operator(value)
  case value
  when ":",
    "?"
    return true
  else
    return false
  end
end

def is_non_token(value)
  case value
  when "\n",
    "\t",
    " "
    return true
  else
    return false
  end
end

def is_single_quote(value)
  value == "\'"
end

def is_double_quote(value)
  value == "\""
end

def is_e(value)
  value == 'e'
end

def is_char(value)
  value.ord >= 32 && value.ord <= 126
end

def is_digit(value)
  value >= '0' && value <= '9'
end

def is_hexa(value)
  is_digit(value) || ('a' <= value && value <= 'f')
end

def is_escape(value)
  value == "\\"
end

def is_new_line(value)
  value == "\n"
end

def anything(value)
  true
end

def is_letter(value)
  ('a' <= value && value <= 'z') || ('A' <= value && value <= 'Z')
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
