require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

INVALID_SECTION_REGEX = /don't\(\).+?(do\(\)|$)/.freeze
VALID_INSTRUCT_REGEX  = /mul\(([0-9]{1,3}),([0-9]{1,3})\)/.freeze

valid_memory = helper.input.gsub(/\n+\s*/m, ' ').gsub(INVALID_SECTION_REGEX, '')

sum = valid_memory.scan(VALID_INSTRUCT_REGEX)
                  .map { |num1, num2| num1.to_i * num2.to_i }
                  .sum

puts sum
