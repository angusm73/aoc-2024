require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

class ReindeerMazeSolver
  DIRECTIONS = [
    [0, 1], # East
    [1, 0], # South
    [0, -1], # West
    [-1, 0] # North
  ].freeze

  def initialize(map)
    @map    = map.split("\n")
    @height = @map.length
    @width  = @map[0].length
    @start  = find_position('S')
    @end    = find_position('E')
  end

  def solve
    queue = [
      {
        pos: @start,
        dir: 0, # Start facing East
        score: 0,
        visited: Set.new
      }
    ]
    best_score  = Float::INFINITY
    seen_states = {}

    until queue.empty?
      current = queue.shift

      # If reached end, update best score
      if current[:pos] == @end
        best_score = [best_score, current[:score]].min
        next
      end

      # Pruning: Skip if we've seen a better state
      state_key = [current[:pos], current[:dir]]
      next if seen_states[state_key] && seen_states[state_key] <= current[:score]

      seen_states[state_key] = current[:score]

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
        score: current[:score] + 1000,
        visited: current[:visited]
      }

      # Try rotating counterclockwise
      queue << {
        pos: current[:pos],
        dir: (current[:dir] - 1 + 4) % 4,
        score: current[:score] + 1000,
        visited: current[:visited]
      }

      # Sort to prioritize lower scores
      queue.sort_by! { |state| state[:score] }
      queue = queue.first(5000) # Limit queue size to prevent memory explosion
    end

    best_score
  end

  private

  def find_position(char)
    @map.each_with_index do |row, y|
      x = row.index(char)
      return [y, x] if x
    end
    nil
  end

  def valid_move?(pos)
    y, x = pos
    return false if y.negative? || y >= @height || x.negative? || x >= @width

    @map[y][x] != '#'
  end
end

solver = ReindeerMazeSolver.new(helper.input)
puts solver.solve
