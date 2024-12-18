require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

class BitMaze
  attr_accessor :grid

  DIRECTIONS = [
    [0, 1], # East
    [1, 0], # South
    [0, -1], # West
    [-1, 0] # North
  ].freeze

  def initialize(corrupt_positions, rows, cols)
    @corrupt_positions = corrupt_positions.map { |pos| pos.split(',').map(&:to_i) }
    @rows              = rows + 1
    @cols              = cols + 1
    @start             = [0, 0]
    @end               = [rows, cols]

    @grid = Array.new(@rows) { Array.new(@cols, '.') }
  end

  def simulate(nanoseconds)
    @corrupt_positions.first(nanoseconds).each do |position|
      grid[position[1]][position[0]] = '#'
    end
  end

  def solution_path
    queue = [
      {
        pos: @start,
        dir: 0, # Start facing East
        score: 0,
        visited: Set.new
      }
    ]
    seen_states = {}

    until queue.empty?
      current = queue.shift

      # If reached end, this maze is solvable
      return current[:visited] if current[:pos] == @end

      # Pruning: Skip if we've seen a better state
      state_key = [current[:pos], current[:dir]]
      next if seen_states[state_key] && seen_states[state_key] <= current[:visited].size

      seen_states[state_key] = current[:visited].size

      # Try moving forward
      forward_pos = [
        current[:pos][0] + DIRECTIONS[current[:dir]][0],
        current[:pos][1] + DIRECTIONS[current[:dir]][1]
      ]

      if valid_move?(forward_pos)
        queue << {
          pos: forward_pos,
          dir: current[:dir],
          score: current[:score] + 1,
          visited: current[:visited] + [current[:pos]]
        }
      end

      # Try rotating clockwise
      queue << {
        pos: current[:pos],
        dir: (current[:dir] + 1) % 4,
        score: current[:score] + 1,
        visited: current[:visited]
      }

      # Try rotating counterclockwise
      queue << {
        pos: current[:pos],
        dir: (current[:dir] - 1 + 4) % 4,
        score: current[:score] + 1,
        visited: current[:visited]
      }

      # Sort to prioritize lower scores
      queue.sort_by! { |state| state[:score] }
      queue = queue.first(5000) # Limit queue size to prevent memory explosion
    end

    nil
  end

  def to_s
    output = ['']
    grid.each do |row|
      output << row.join
    end
    output.join("\n")
  end

  private

  def valid_move?(pos)
    y, x = pos
    return false if y.negative? || y >= @rows || x.negative? || x >= @cols

    @grid[y][x] != '#'
  end
end

size        = helper.demo? ? [6, 6] : [70, 70]
nanoseconds = helper.demo? ? 12 : 1024

lines = helper.input_lines
maze  = BitMaze.new(lines, *size)
path  = maze.solution_path
(nanoseconds..lines.size).each do |count|
  position = lines[count - 1].split(',').map(&:to_i)
  puts "New corruption (#{count}): #{position.join(',')}"

  next unless path&.include?(position.reverse)

  maze.simulate(count)

  path = maze.solution_path
  if path.nil?
    puts "Can't solve"
    break
  end
end
