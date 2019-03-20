require_relative "dfa"

class Analyzer
  attr_accessor :dfa

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
  end

  def get_token
    r = dfa.execute
    final_state = r.first
    token_value = r.second

    if (final_state == Dfa::ERROR)
      puts "EROARE  - " + token_value + " POZITIA - " + dfa.get_position
    end


  end
end
