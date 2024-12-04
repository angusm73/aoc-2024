input = File.readlines(File.join(File.dirname(__FILE__), './input'))

grid       = []
xmas_count = 0

input.each do |line|
  grid << line.chomp.chars
end

WIDTH    = grid[0].count
HEIGHT   = grid.count
XMAS     = 'XMAS'.freeze

DIRECTIONS = [
  [0, 1], # right
  [1, 0], # down
  [1, 1], # diagonal down-right
  [1, -1], # diagonal down-left
  [0, -1], # left
  [-1, 0], # up
  [-1, -1], # diagonal up-left
  [-1, 1] # diagonal up-right
].freeze

HEIGHT.times do |row|
  WIDTH.times do |col|
    DIRECTIONS.each do |dr, dc|
      next if (row + dr * 3).negative? || row + dr * 3 >= HEIGHT ||
              (col + dc * 3).negative? || col + dc * 3 >= WIDTH

      match      = XMAS.chars.each_with_index.all? do |char, i|
        grid[row + dr * i][col + dc * i] == char
      end

      xmas_count += 1 if match
    end
  end
end

puts xmas_count
