require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

class UnsafeLevels < StandardError; end

def ascending?(levels)
  levels.first < levels.last
end

def validate_step!(level, next_level, direction)
  difference = next_level - level

  safe_range = if direction == :asc
                 (1..3)
               else
                 (-3..-1)
               end

  raise UnsafeLevels unless safe_range.include?(difference)
end

def unsafe_level_index(levels)
  direction     = ascending?(levels) ? :asc : :desc
  current_index = 0

  levels.each_with_index do |level, index|
    current_index = index
    next if index.zero?

    validate_step!(levels[index - 1], level, direction)
  end

  false
rescue UnsafeLevels
  current_index
end

def safe?(levels)
  bad_index = unsafe_level_index(levels)

  if bad_index
    new_levels1 = levels.dup.tap { |l| l.delete_at(bad_index) }
    new_levels2 = levels.dup.tap { |l| l.delete_at(bad_index - 1) }

    if unsafe_level_index(new_levels1)
      return true unless unsafe_level_index(new_levels2)

      return false
    end
  end

  true
end

total_safe = helper.input_lines.count do |report|
  levels = report.split.map(&:to_i)
  safe?(levels)
end

puts total_safe
