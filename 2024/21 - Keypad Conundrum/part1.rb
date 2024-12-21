require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

class Keypad
  DIRECTIONS = { v: [0, 1], '^': [0, -1], '>': [1, 0], '<': [-1, 0] }.freeze

  def initialize
    @height = self.class::KEYPAD.size
    @width  = self.class::KEYPAD.first.size
  end

  def paths(start_btn, end_btn)
    start_pos = find_pos(start_btn)
    end_pos   = find_pos(end_btn)
    blank     = find_pos(' ')
    seen      = [start_pos, blank]
    queue     = [{ pos: start_pos, path: '' }]
    paths     = []

    min_distance = Float::INFINITY
    distance     = 0

    while !queue.empty? && distance <= min_distance
      current  = queue.shift
      distance = current[:path].size

      if current[:pos] == end_pos
        min_distance = distance
        paths << "#{current[:path]}A"
        next
      end

      DIRECTIONS.each do |button, direction|
        new_pos = [current[:pos][0] + direction[1], current[:pos][1] + direction[0]]
        queue << { pos: new_pos, path: current[:path] + button.to_s } if valid_move?(new_pos) && !seen.include?(new_pos)
      end

      seen << current[:pos]
    end

    paths
  end

  private

  def find_pos(btn)
    self.class::KEYPAD.each_with_index do |row, y|
      x = row.index(btn)
      return [y, x] if x
    end
    nil
  end

  def valid_move?(pos)
    y, x = pos
    return false if y.negative? || y >= @height || x.negative? || x >= @width

    self.class::KEYPAD[y][x] != ' '
  end
end

class NumericKeypad < Keypad
  KEYPAD = [%w[7 8 9], %w[4 5 6], %w[1 2 3], [' ', '0', 'A']].freeze
end

class DirectionalKeypad < Keypad
  KEYPAD = [[' ', '^', 'A'], %w[< v >]].freeze
end

class DoorCodeSolver
  def initialize
    @numeric_keypad     = NumericKeypad.new
    @directional_keypad = DirectionalKeypad.new
  end

  def min_length_DPAD(sequence, depth)
    return sequence.size if depth.zero?

    min_size = 0
    prev     = 'A'
    sequence.each_char do |character|
      paths        = @directional_keypad.paths(prev, character)
      path_lengths = paths.map { |path| min_length_DPAD(path, depth - 1) }
      prev         = character
      min_size += path_lengths.min
    end

    min_size
  end

  # Calculate complexity for a single code
  def calculate_complexity(code, depth)
    prev          = 'A'
    min_size      = 0
    numeric_value = code.to_i

    code.each_char do |character|
      paths        = @numeric_keypad.paths(prev, character)
      path_lengths = paths.map { |path| min_length_DPAD(path, depth) }
      prev         = character
      min_size += path_lengths.min
    end

    puts "#{code}: #{min_size} x #{numeric_value}"

    min_size * numeric_value
  end

  # Calculate total complexity for a list of codes
  def calculate_total_complexity(codes, depth = 2)
    codes.sum { |code| calculate_complexity(code, depth) }
  end
end

solver = DoorCodeSolver.new

puts solver.calculate_total_complexity(helper.input_lines.map(&:chomp))
