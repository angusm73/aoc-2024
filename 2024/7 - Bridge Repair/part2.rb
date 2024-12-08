require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

def solve_calibrations(input)
  total_calibration_result = 0

  # Process each line of input
  lines = input.strip.split("\n")
  lines.each_with_index do |line, i|
    # Parse the line
    test_value, numbers_str = line.split(': ')
    test_value              = test_value.to_i
    numbers                 = numbers_str.split.map(&:to_i)

    # Check if this equation can be made true
    puts "#{i + 1} / #{lines.count}"
    total_calibration_result += test_value if equation_possible?(numbers, test_value)
  end

  total_calibration_result
end

def equation_possible?(numbers, target)
  # Generate all possible combinations of operators
  operators = %i[+ * ||]
  eq_cache  = {}

  # Generate all possible operator configurations
  possible_configs = operators.repeated_permutation(numbers.length - 1).to_a
  puts "#{possible_configs.count} configs found" if block_given?
  possible_configs.each do |op_config|
    equation = numbers.zip(op_config + [nil]).flatten.compact
    result   = evaluate_equation(equation, eq_cache)
    return true if result == target
  end

  false
end

def evaluate_equation(equation, eq_cache)
  return equation if equation.is_a?(Integer)
  return eq_cache[equation] if eq_cache.key?(equation)

  # Handle array of operators & numbers
  result = equation[0]
  (1...equation.length).step(2).each do |i|
    op     = equation[i]
    num    = equation[i + 1]
    result = case op
             when :+
               result + num
             when :*
               result * num
             when :"||"
               (result.to_s + num.to_s).to_i
             else
               result
             end
  end

  eq_cache[equation] = result
  result
end

puts solve_calibrations(helper.input)
