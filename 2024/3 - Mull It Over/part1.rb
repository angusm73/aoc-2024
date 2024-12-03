input = File.read(File.join(File.dirname(__FILE__), './input'))

VALID_INSTRUCT_REGEX = /mul\(([0-9]{1,3}),([0-9]{1,3})\)/.freeze

sum = 0

input.scan(VALID_INSTRUCT_REGEX).each do |num1, num2|
  sum += num1.to_i * num2.to_i
end

puts sum
