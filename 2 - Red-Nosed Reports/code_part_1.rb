reports = File.readlines('./2 - Red-Nosed Reports/input')

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

total_safe = reports.count do |report|
  levels = report.split.map(&:to_i)
  safe?(levels)
end

puts total_safe
