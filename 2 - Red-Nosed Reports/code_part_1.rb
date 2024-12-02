reports = File.readlines('./2 - Red-Nosed Reports/input')

class UnsafeLevels < StandardError; end

def ascending?(levels)
  levels.first < levels.last
end

def safe_step?(level, next_level, direction)
  difference = next_level - level

  safe_range = if direction == :asc
                 (1..3)
               else
                 (-3..-1)
               end

  safe_range.include?(difference)
end

def safe?(levels)
  direction = ascending?(levels) ? :asc : :desc
  levels.each_with_index do |level, index|
    next if index.zero? || safe_step?(levels[index - 1], level, direction)

    raise UnsafeLevels
  end

  true
rescue UnsafeLevels
  false
end

total_safe = 0

reports.each do |report|
  levels = report.split.map(&:to_i)
  total_safe += 1 if safe?(levels)
end

puts total_safe
