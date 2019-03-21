require_relative "helper_methods"
require_relative "dfa_state"
require_relative "dfa_transitions"

class Dfa
  attr_accessor :fp, :file_name, :transitions, :file_position

  STATE = DFA_STATE

  def initialize(file_name)
    @file_name = file_name
    @transitions = dfa_transitions
    @file_position = 0
  end

  def execute
    current_state = STATE[:initial]
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
        return [current_state, token_value]
      end
    end

    return [STATE[:error], token_value]
  end

  def is_EOF
    @file_position >= File.open(file_name, "r").size
  end

  def get_position
    @file_position
  end
end
