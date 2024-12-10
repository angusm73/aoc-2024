require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

class TopographicMap
  def initialize(map_input)
    @map  = map_input.split("\n").map { |row| row.chars.map(&:to_i) }
    @rows = @map.length
    @cols = @map[0].length
  end

  def calculate_trailhead_scores
    trailheads = find_trailheads
    puts "found #{trailheads.count} trailheads"
    trailheads.map { |trailhead| score_trailhead(trailhead) }.sum
  end

  private

  def find_trailheads
    trailheads = []
    @map.each_with_index do |row, r|
      row.each_with_index do |height, c|
        trailheads << [r, c] if height.zero?
      end
    end
    trailheads
  end

  def score_trailhead(start)
    visited_peaks = Set.new

    # Depth-first search to explore all possible trails
    dfs = lambda do |r, c, prev_height, path|
      # Out of bounds
      return if r.negative? || r >= @rows ||
                c.negative? || c >= @cols

      # Invalid trail conditions
      return unless @map[r][c] == prev_height + 1

      # Prevent revisiting
      path_key = "#{r},#{c},#{prev_height}"
      return if path.include?(path_key)

      puts "path: #{path}"
      puts "current: #{r}, #{c} (#{@map[r][c]})"

      # Mark peak if reached
      visited_peaks.add([r, c]) if @map[r][c] == 9
      puts "Found trail end #{r}, #{c}" if @map[r][c] == 9

      # Continue exploring in 4 directions
      [[0, 1], [0, -1], [1, 0], [-1, 0]].each do |dr, dc|
        next_r = r + dr
        next_c = c + dc
        dfs.call(next_r, next_c, @map[r][c], path + [path_key])
      end
    end

    # Start the search from the trailhead
    dfs.call(start[0], start[1], -1, [])

    visited_peaks.size
  end
end

map = TopographicMap.new(helper.input)
puts map.calculate_trailhead_scores
