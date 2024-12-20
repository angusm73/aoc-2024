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
      # Find all possible end positions within 20 steps using BFS
      possible_ends = find_cheat_endpoints(start_pos)

      possible_ends.each do |end_pos, cheat_length|
        # Skip if end position can't reach finish
        dist_from_end = @distances_from_end[end_pos]
        next unless dist_from_end

        # Calculate total time with this cheat
        time_with_cheat = dist_to_start + cheat_length + dist_from_end
        time_saved = @normal_time - time_with_cheat

        good_cheats.add([start_pos, end_pos]) if time_saved >= min_saving
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

  def find_cheat_endpoints(start_pos)
    endpoints = {}
    visited = Set.new
    queue = [[start_pos, 0]]
    visited.add(start_pos)

    until queue.empty?
      pos, steps = queue.shift
      next if steps > 20 # Maximum cheat length

      # If this is a valid track position and we went through at least one wall,
      # it's a potential endpoint
      endpoints[pos] = steps if steps.positive? && valid_track?(pos) && path_contains_wall?(start_pos, pos)

      # Try all directions
      DIRECTIONS.each do |dy, dx|
        new_pos = Point.new(pos.y + dy, pos.x + dx)
        next unless valid_position?(new_pos)
        next if visited.include?(new_pos)

        visited.add(new_pos)
        queue << [new_pos, steps + 1]
      end
    end

    endpoints
  end

  def path_contains_wall?(start_pos, end_pos)
    visited = Set.new
    queue = [[start_pos, []]]

    until queue.empty?
      pos, path = queue.shift
      return true if path.any? { |p| @grid[p.y][p.x] == '#' }
      return true if @grid[pos.y][pos.x] == '#'
      next if path.length >= 20

      return path.any? { |p| @grid[p.y][p.x] == '#' } if pos == end_pos

      DIRECTIONS.each do |dy, dx|
        new_pos = Point.new(pos.y + dy, pos.x + dx)
        next unless valid_position?(new_pos)
        next if visited.include?(new_pos)

        visited.add(new_pos)
        queue << [new_pos, path + [pos]]
      end
    end

    false
  end
end

track = RaceTrack.new(helper.input)
puts track.count_good_cheats(helper.demo? ? 50 : 100) # 285 for demo
