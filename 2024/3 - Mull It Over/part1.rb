input = File.read(File.join(File.dirname(__FILE__), './input'))

VALID_INSTRUCT_REGEX = /mul\(([0-9]{1,3}),([0-9]{1,3})\)/.freeze

sum = input.scan(VALID_INSTRUCT_REGEX)
           .map { |num1, num2| num1.to_i * num2.to_i }
           .sum

puts sum
