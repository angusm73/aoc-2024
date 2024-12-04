input = File.readlines(File.join(File.dirname(__FILE__), './input'))

grid       = []
xmas_count = 0

input.each do |line|
  grid << line.chomp.chars
end

WIDTH   = grid.first.count
HEIGHT  = grid.count
MAS     = %w[M A S].freeze
MAS_LEN = MAS.count

def traverse(grid, x, y, length, &block)
  (0...length).map do |_|
    char = grid[x][y]
    x, y = block.call(x, y)
    char
  end
end

def left(grid, x, y)
  return false if (x + 1 - MAS_LEN).negative?

  traverse(grid, x, y, MAS_LEN) { |x, y| [x - 1, y] }
end

def right(grid, x, y)
  return false if x + MAS_LEN > WIDTH

  traverse(grid, x, y, MAS_LEN) { |x, y| [x + 1, y] }
end

def up(grid, x, y)
  return false if (y + 1 - MAS_LEN).negative?

  traverse(grid, x, y, MAS_LEN) { |x, y| [x, y - 1] }
end

def down(grid, x, y)
  return false if y + MAS_LEN > HEIGHT

  traverse(grid, x, y, MAS_LEN) { |x, y| [x, y + 1] }
end

def up_left(grid, x, y)
  return false if (y + 1 - MAS_LEN).negative? || (x + 1 - MAS_LEN).negative?

  traverse(grid, x, y, MAS_LEN) { |x, y| [x - 1, y - 1] }
end

def up_right(grid, x, y)
  return false if (y + 1 - MAS_LEN).negative? || x + MAS_LEN > WIDTH

  traverse(grid, x, y, MAS_LEN) { |x, y| [x + 1, y - 1] }
end

def down_left(grid, x, y)
  return false if y + MAS_LEN > HEIGHT || (x + 1 - MAS_LEN).negative?

  traverse(grid, x, y, MAS_LEN) { |x, y| [x - 1, y + 1] }
end

def down_right(grid, x, y)
  return false if y + MAS_LEN > HEIGHT || x + MAS_LEN > WIDTH

  traverse(grid, x, y, MAS_LEN) { |x, y| [x + 1, y + 1] }
end

def mas?(letters)
  letters == MAS || letters == MAS.reverse
end

def xmas?(grid, x, y)
  mas?(down_right(grid, x, y)) && mas?(down_left(grid, x + 2, y))
end

(0...HEIGHT).each do |y|
  (0...WIDTH).each do |x|
    char = grid[x][y]
    next unless char == 'M' || char == 'S'

    xmas_count += 1 if xmas?(grid, x, y)
  end
end

puts xmas_count
