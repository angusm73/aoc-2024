require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

def calculate_guard_path(map)
  # Parse the map
  grid    = map.strip.split("\n").map(&:chars)
  visited = {}

  # Find starting position and direction
  start_row, start_col, direction = find_start(grid)

  directions = {
    up: [-1, 0],
    right: [0, 1],
    down: [1, 0],
    left: [0, -1]
  }

  turn_right = {
    up: :right,
    right: :down,
    down: :left,
    left: :up
  }

  # Mark starting position
  visited[[start_row, start_col]] = 1
  current_row                     = start_row
  current_col                     = start_col

  # Simulate guard movement
  loop do
    # Try to turn and move
    current_direction = direction

    # Calculate next position in current direction
    dr, dc   = directions[current_direction]
    next_row = current_row + dr
    next_col = current_col + dc

    break if next_row >= grid.length || next_col >= grid[0].length

    # Check if next position is out of bounds or obstructed
    if next_row.negative? || next_row >= grid.length ||
       next_col.negative? || next_col >= grid[0].length ||
       grid[next_row][next_col] == '#'
      # Turn right
      direction = turn_right[current_direction]
      # puts "#{current_direction} => #{direction}"
      next
    end

    # Move forward
    current_row = next_row
    current_col = next_col

    # Mark visited
    visited[[current_row, current_col]] ||= 0
    visited[[current_row, current_col]] += 1
  rescue StandardError
    # Exit loop when guard leaves mapped area
    break
  end

  # Return number of distinct visited positions
  visited
end

def find_possible_obstructions(map)
  # Parse the map
  grid           = map.strip.split("\n").map(&:chars)
  loop_positions = Set.new

  # Find starting position and direction
  start_row, start_col, start_direction = find_start(grid)

  visited_cells = calculate_guard_path(map)

  visited_cells.each_key do |(r, c)|
    test_grid       = grid.map(&:dup)
    test_grid[r][c] = '#'

    if causes_loop?(test_grid, start_row, start_col, start_direction)
      loop_positions.add([r, c])
      puts "#{r}, #{c} causes loop"
    end
  end

  loop_positions.size
end

def causes_loop?(grid, start_row, start_col, start_direction)
  visited     = {}
  current_row = start_row
  current_col = start_col
  direction   = start_direction

  directions = {
    up: [-1, 0],
    right: [0, 1],
    down: [1, 0],
    left: [0, -1]
  }

  turn_right = {
    up: :right,
    right: :down,
    down: :left,
    left: :up
  }

  max_iterations = grid.length * grid[0].length * 4 # Prevent infinite loops

  max_iterations.times do
    # Calculate next position in current direction
    dr, dc   = directions[direction]
    next_row = current_row + dr
    next_col = current_col + dc

    break if next_row.negative? || next_col.negative? || next_row >= grid.length || next_col >= grid[0].length

    # Turn right if blocked
    if grid[next_row][next_col] == '#'
      direction = turn_right[direction]
      next
    end

    # Move to next position
    current_row = next_row
    current_col = next_col

    # Track visits
    visit_key = [current_row, current_col, direction]
    visited[visit_key] ||= 0
    visited[visit_key] += 1

    # Check for a loop (visiting the same position and direction multiple times)
    return true if visited[visit_key] > 1
  end

  false
end

def find_start(grid)
  grid.each_with_index do |row, r|
    row.each_with_index do |cell, c|
      case cell
      when '^' then return [r, c, :up]
      when 'v' then return [r, c, :down]
      when '>' then return [r, c, :right]
      when '<' then return [r, c, :left]
      else next
      end
    end
  end
  nil
end

puts find_possible_obstructions(helper.input)
