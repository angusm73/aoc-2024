require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

def solve_calibrations(input)
  total_calibration_result = 0

  # Process each line of input
  input.strip.split("\n").each do |line|
    # Parse the line
    test_value, numbers_str = line.split(': ')
    test_value              = test_value.to_i
    numbers                 = numbers_str.split.map(&:to_i)

    # Check if this equation can be made true
    total_calibration_result += test_value if equation_possible?(numbers, test_value)
  end

  total_calibration_result
end

def equation_possible?(numbers, target)
  possible_configs = generate_operator_configurations(numbers.length - 1)

  # Try each configuration of operators
  possible_configs.any? do |config|
    evaluate_equation(numbers, config) == target
  end
end

def generate_operator_configurations(num_ops)
  # Generate all possible combinations of + and * operators
  %i[+ *].repeated_permutation(num_ops).to_a
end

def evaluate_equation(numbers, operators)
  # Evaluate the equation left to right with given operators
  result = numbers[0]
  numbers[1..].zip(operators).each do |num, op|
    result = result.send(op, num)
  end
  result
end

puts solve_calibrations(helper.input)
