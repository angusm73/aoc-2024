require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

class AntennaMap
  def initialize(map_input)
    @map      = map_input.split("\n")
    @height   = @map.length
    @width    = @map[0].length
    @antennas = find_antennas
  end

  def find_antennas
    antennas = Hash.new { |h, k| h[k] = [] }
    @map.each_with_index do |row, y|
      row.chars.each_with_index do |char, x|
        antennas[char] << [x, y] if char =~ /[a-zA-Z0-9]/
      end
    end
    antennas
  end

  def calculate_antinodes
    antinodes = Set.new

    @antennas.each_value do |locations|
      # Check every pair of antennas with this frequency
      locations.combination(2).each do |ant1, ant2|
        dx = ant2[0] - ant1[0]
        dy = ant2[1] - ant1[1]

        # First antinode: beyond ant2 from ant1's perspective
        antinode1_x = ant2[0] + dx
        antinode1_y = ant2[1] + dy

        # Second antinode: beyond ant1 from ant2's perspective
        antinode2_x = ant1[0] - dx
        antinode2_y = ant1[1] - dy

        # Add antinodes if within map bounds
        antinodes << [antinode1_x, antinode1_y] if valid_coordinate?(antinode1_x, antinode1_y)
        antinodes << [antinode2_x, antinode2_y] if valid_coordinate?(antinode2_x, antinode2_y)
      end
    end

    antinodes
  end

  def valid_coordinate?(x, y)
    x >= 0 && x < @width && y >= 0 && y < @height
  end

  def count_antinodes
    calculate_antinodes.size
  end
end

antenna_map = AntennaMap.new(helper.input)
puts antenna_map.count_antinodes
