require_relative "analyzer"
require_relative "token"

file_input = "input.txt"

analyzer = Analyzer.new(file_input)
File.open("output.txt", "w") do |file|
  while (token = analyzer.get_token())
    file.write token.get_string(analyzer) + "\n"
  end
end
