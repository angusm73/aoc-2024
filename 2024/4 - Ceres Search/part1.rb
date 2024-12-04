input = File.readlines(File.join(File.dirname(__FILE__), './input'))

grid       = []
xmas_count = 0

input.each do |line|
  grid << line.chomp.chars
end

WIDTH    = grid.first.count
HEIGHT   = grid.count
XMAS     = %w[X M A S].freeze
XMAS_LEN = XMAS.count

def traverse(grid, x, y, length, &block)
  (0...length).map do |_|
    char = grid[x][y]
    x, y = block.call(x, y)
    char
  end
end

def left(grid, x, y)
  return false if (x + 1 - XMAS_LEN).negative?

  traverse(grid, x, y, XMAS_LEN) { |x, y| [x - 1, y] } == XMAS
end

def right(grid, x, y)
  return false if x + XMAS_LEN > WIDTH

  traverse(grid, x, y, XMAS_LEN) { |x, y| [x + 1, y] } == XMAS
end

def up(grid, x, y)
  return false if (y + 1 - XMAS_LEN).negative?

  traverse(grid, x, y, XMAS_LEN) { |x, y| [x, y - 1] } == XMAS
end

def down(grid, x, y)
  return false if y + XMAS_LEN > HEIGHT

  traverse(grid, x, y, XMAS_LEN) { |x, y| [x, y + 1] } == XMAS
end

def up_left(grid, x, y)
  return false if (y + 1 - XMAS_LEN).negative? || (x + 1 - XMAS_LEN).negative?

  traverse(grid, x, y, XMAS_LEN) { |x, y| [x - 1, y - 1] } == XMAS
end

def up_right(grid, x, y)
  return false if (y + 1 - XMAS_LEN).negative? || x + XMAS_LEN > WIDTH

  traverse(grid, x, y, XMAS_LEN) { |x, y| [x + 1, y - 1] } == XMAS
end

def down_left(grid, x, y)
  return false if y + XMAS_LEN > HEIGHT || (x + 1 - XMAS_LEN).negative?

  traverse(grid, x, y, XMAS_LEN) { |x, y| [x - 1, y + 1] } == XMAS
end

def down_right(grid, x, y)
  return false if y + XMAS_LEN > HEIGHT || x + XMAS_LEN > WIDTH

  traverse(grid, x, y, XMAS_LEN) { |x, y| [x + 1, y + 1] } == XMAS
end

def match_count(grid, x, y)
  [
    left(grid, x, y),
    right(grid, x, y),
    up(grid, x, y),
    down(grid, x, y),
    up_left(grid, x, y),
    up_right(grid, x, y),
    down_left(grid, x, y),
    down_right(grid, x, y)
  ].count(true)
end

(0...HEIGHT).each do |y|
  (0...WIDTH).each do |x|
    char = grid[x][y]
    next unless char == 'X'

    xmas_count += match_count(grid, x, y)
  end
end

puts xmas_count
