require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

class WarehouseRobot
  def initialize(grid, moves)
    @grid      = grid.map(&:chars)
    @moves     = moves.delete("\n").chars
    @robot_pos = find_robot
  end

  def find_robot
    @grid.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        return [y, x] if cell == '@'
      end
    end
  end

  def valid_move?(y, x)
    @grid[y][x] != '#'
  end

  def move_box(y, x, dy, dx)
    # Find all consecutive boxes in the direction of movement
    boxes = [[y, x]]
    curr_y = y
    curr_x = x

    while @grid[curr_y + dy][curr_x + dx] == 'O'
      curr_y += dy
      curr_x += dx
      boxes << [curr_y, curr_x]
    end

    # Check if the space after the last box is valid
    final_y = boxes.last[0] + dy
    final_x = boxes.last[1] + dx
    return false unless valid_move?(final_y, final_x)

    # Move all boxes starting from the furthest one
    boxes.reverse.each do |box_y, box_x|
      @grid[box_y][box_x] = '.'
      @grid[box_y + dy][box_x + dx] = 'O'
    end

    true
  end

  def move_robot(dy, dx)
    y, x  = @robot_pos
    new_y = y + dy
    new_x = x + dx

    # If new position is blocked by a wall, do nothing
    return false unless valid_move?(new_y, new_x)

    # Check if there's a box in the way
    if @grid[new_y][new_x] == 'O' && !move_box(new_y, new_x, dy, dx)
      # Try to push the box
      return false
    end

    # Move robot
    @grid[y][x]         = '.'
    @grid[new_y][new_x] = '@'
    @robot_pos          = [new_y, new_x]
    true
  end

  def perform_moves
    moves_map = {
      '^' => [-1, 0],
      'v' => [1, 0],
      '<' => [0, -1],
      '>' => [0, 1]
    }

    @moves.each do |move|
      dy, dx = moves_map[move]
      move_robot(dy, dx)
    end
  end

  def calculate_gps_coordinates
    coordinates = []
    @grid.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        coordinates << (y * 100 + x) if cell == 'O'
      end
    end
    coordinates.sum
  end

  def solve
    perform_moves
    calculate_gps_coordinates
  end

  def to_s
    @grid.map(&:join).join
  end
end

grid  = helper.input.split("\n\n").first.lines
moves = helper.input.split("\n\n").last

warehouse = WarehouseRobot.new(grid, moves)
puts warehouse.solve
