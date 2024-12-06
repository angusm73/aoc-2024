require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

def safe?(levels)
  # Check if all increasing
  increasing = levels.each_cons(2).all? do |a, b|
    (b - a).between?(1, 3)
  end

  # Check if all decreasing
  decreasing = levels.each_cons(2).all? do |a, b|
    (a - b).between?(1, 3)
  end

  increasing || decreasing
end

total_safe = helper.input_lines.count do |report|
  levels = report.split.map(&:to_i)
  safe?(levels)
end

puts total_safe
