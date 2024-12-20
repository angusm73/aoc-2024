require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

class RaceTrack
  DIRECTIONS = [[0, 1], [1, 0], [0, -1], [-1, 0]].freeze
  Point      = Struct.new(:y, :x) do
    def +(other)
      Point.new(y + other.y, x + other.x)
    end

    def -(other)
      Point.new(y - other.y, x - other.x)
    end

    def manhattan_distance(other)
      (y - other.y).abs + (x - other.x).abs
    end
  end

  def initialize(input)
    @grid                 = input.split("\n").map(&:chars)
    @height               = @grid.length
    @width                = @grid[0].length
    @distances_from_end   = {}
    @distances_from_start = {}
    find_start_and_end
    calculate_distances(@distances_from_end, @end)
    calculate_distances(@distances_from_start, @start)
    @normal_time = @distances_from_start[@end]
  end

  def count_good_cheats(min_saving)
    return 0 unless @normal_time # No path exists

    good_cheats = Set.new

    # Consider all reachable points as potential cheat start positions
    @distances_from_start.each do |start_pos, dist_to_start|
      # For each possible end position within 2 steps
      (-2..2).each do |dy|
        (-2..2).each do |dx|
          next if dy.abs + dx.abs > 2 # Must be within 2 Manhattan distance
          next if dy.zero? && dx.zero? # Must actually move

          end_pos = Point.new(start_pos.y + dy, start_pos.x + dx)
          next unless valid_position?(end_pos)
          next unless valid_track?(end_pos)

          # Check if this cheat goes through at least one wall
          next unless passes_through_wall?(start_pos, end_pos)

          # Calculate time with this cheat
          dist_from_end = @distances_from_end[end_pos]
          next unless dist_from_end # Skip if end position can't reach finish

          cheat_distance  = start_pos.manhattan_distance(end_pos)
          time_with_cheat = dist_to_start + cheat_distance + dist_from_end
          time_saved      = @normal_time - time_with_cheat

          good_cheats.add([start_pos, end_pos]) if time_saved >= min_saving
        end
      end
    end

    good_cheats.size
  end

  private

  def find_start_and_end
    @grid.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        pos    = Point.new(y, x)
        @start = pos if cell == 'S'
        @end   = pos if cell == 'E'
      end
    end
  end

  def calculate_distances(distances, start_point)
    queue                  = [[start_point, 0]]
    distances[start_point] = 0

    until queue.empty?
      pos, dist = queue.shift

      DIRECTIONS.each do |dy, dx|
        new_pos = Point.new(pos.y + dy, pos.x + dx)

        if valid_track?(new_pos) && !distances.key?(new_pos)
          distances[new_pos] = dist + 1
          queue << [new_pos, dist + 1]
        end
      end
    end
  end

  def valid_track?(pos)
    return false unless valid_position?(pos)

    cell = @grid[pos.y][pos.x]
    %w[. S E].include?(cell)
  end

  def valid_position?(pos)
    pos.y >= 0 && pos.y < @height && pos.x >= 0 && pos.x < @width
  end

  def passes_through_wall?(start_pos, end_pos)
    # Check if there's at least one wall in the direct path between points
    dy = end_pos.y - start_pos.y
    dx = end_pos.x - start_pos.x

    steps = [dy.abs, dx.abs].max
    return false if steps.zero?

    step_y = dy.to_f / steps
    step_x = dx.to_f / steps

    (1..steps).each do |i|
      y = start_pos.y + (step_y * i).round
      x = start_pos.x + (step_x * i).round
      return true if @grid[y][x] == '#'
    end

    false
  end
end

track = RaceTrack.new(helper.input)
puts track.count_good_cheats(helper.demo? ? 0 : 100)
