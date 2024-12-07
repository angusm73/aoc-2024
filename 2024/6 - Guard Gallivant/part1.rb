require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

def calculate_guard_path(map)
  # Parse the map
  grid = map.strip.split("\n").map(&:chars)
  visited = {}

  # Find starting position and direction
  start_row = nil
  start_col = nil
  direction = nil

  grid.each_with_index do |row, r|
    row.each_with_index do |cell, c|
      case cell
      when '^'
        start_row = r
        start_col = c
        direction = :up
        break
      when 'v'
        start_row = r
        start_col = c
        direction = :down
        break
      when '>'
        start_row = r
        start_col = c
        direction = :right
        break
      when '<'
        start_row = r
        start_col = c
        direction = :left
        break
      else
        next
      end
    end
    break if start_row
  end

  # Directions: [row_change, col_change]
  directions = {
    up: [-1, 0],
    right: [0, 1],
    down: [1, 0],
    left: [0, -1]
  }

  # Turning right from current direction
  turn_right = {
    up: :right,
    right: :down,
    down: :left,
    left: :up
  }

  # Mark starting position
  visited[[start_row, start_col]] = true
  current_row = start_row
  current_col = start_col

  puts "(#{direction}) pos #{start_row} #{start_col}"
  puts visited

  # Simulate guard movement
  loop do
    # Try to turn and move
    current_direction = direction

    puts "(#{current_direction}) pos #{current_row} #{current_col}"

    # Calculate next position in current direction
    dr, dc = directions[current_direction]
    next_row = current_row + dr
    next_col = current_col + dc

    break if next_row >= grid.length || next_col >= grid[0].length

    # Check if next position is out of bounds or obstructed
    if next_row.negative? || next_row >= grid.length ||
       next_col.negative? || next_col >= grid[0].length ||
       grid[next_row][next_col] == '#'
      # Turn right
      direction = turn_right[current_direction]
      puts "#{current_direction} => #{direction}"
      next
    end

    # Move forward
    current_row = next_row
    current_col = next_col

    # Mark visited
    visited[[current_row, current_col]] = true
  rescue StandardError
    # Exit loop when guard leaves mapped area
    break
  end

  # Return number of distinct visited positions
  visited.size
end

puts calculate_guard_path(helper.input)
