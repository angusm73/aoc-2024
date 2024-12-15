require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

class WarehouseRobot
  def initialize(grid, moves)
    @grid      = expand_grid(grid)
    @moves     = moves.delete("\n").chars
    @robot_pos = find_robot
  end

  def expand_grid(grid)
    expanded = []
    grid.each do |row|
      expanded_row = row.chars.map do |cell|
        case cell
        when '#' then '##'
        when 'O' then '[]'
        when '.' then '..'
        when '@' then '@.'
        else cell * 2
        end
      end
      expanded << expanded_row.join.chomp
    end
    expanded.map(&:chars)
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

  def move_object_on_expanded_grid(start_pos, dir, swap: true, check: true)
    x, y     = start_pos
    dx, dy   = dir
    target_x = x + dx
    target_y = y + dy
    obj      = @grid[x][y]

    # Check if target is a wall
    return false if @grid[target_x][target_y] == '#'

    # If target is empty, move object
    if @grid[target_x][target_y] == '.'
      if swap
        @grid[target_x][target_y] = obj
        @grid[x][y]               = '.'
      end
      return true
    end

    # Handle big box movement
    if %w[[ ]].include?(@grid[target_x][target_y])
      # Determine matching box tiles
      matching_x = target_x
      matching_y = if @grid[target_x][target_y] == '['
                     target_y + 1
                   else
                     target_y - 1
                   end

      # Horizontal movement
      if [[-1, 0], [1, 0]].include?(dir)
        # Recursively check if matching tiles can be moved
        if check
          return false unless move_object_on_expanded_grid([matching_x, matching_y], dir, swap: false)
          return false unless move_object_on_expanded_grid([target_x, target_y], dir, swap: false)
        end

        # Actually move the matching tiles if swap is true
        move_object_on_expanded_grid([matching_x, matching_y], dir, swap: true, check: false) if swap
      end

      # Move the current object
      if swap
        moved = move_object_on_expanded_grid([target_x, target_y], dir)
        return false unless moved

        @grid[target_x][target_y] = obj
        @grid[x][y]               = '.'
        return true
      end

      return true
    end

    false
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
      @robot_pos = [@robot_pos[0] + dy, @robot_pos[1] + dx] if move_object_on_expanded_grid(@robot_pos, moves_map[move])
    end
  end

  def calculate_gps_coordinates
    coordinates = []
    @grid.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        coordinates << (y * 100 + x) if cell == '['
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
