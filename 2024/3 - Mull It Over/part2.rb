input = File.read(File.join(File.dirname(__FILE__), './input'))

INVALID_SECTION_REGEX = /don't\(\).+?(do\(\)|$)/.freeze
VALID_INSTRUCT_REGEX  = /mul\(([0-9]{1,3}),([0-9]{1,3})\)/.freeze

sum = 0

valid_input = input.gsub(/\n+\s*/m, ' ').gsub(INVALID_SECTION_REGEX, '')

valid_input.scan(VALID_INSTRUCT_REGEX).each do |num1, num2|
  sum += num1.to_i * num2.to_i
end

puts sum
