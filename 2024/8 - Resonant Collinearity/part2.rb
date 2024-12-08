require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

# Map of antenna's + methods to find antinodes
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
      # Skip frequencies with less than 2 antennas
      next if locations.size < 2

      # Check every possible combination of points to find antinodes
      locations.combination(2).each do |ant1, ant2|
        # Include antenna antinodes
        antinodes << [ant1[0], ant1[1]]
        antinodes << [ant2[0], ant2[1]]

        # Extended line search for additional antinodes
        find_line_antinodes(ant1, ant2, antinodes)
      end
    end

    antinodes
  end

  def find_line_antinodes(ant1, ant2, antinodes)
    # Extend the line in both directions to find additional antinodes
    dx = ant2[0] - ant1[0]
    dy = ant2[1] - ant1[1]

    [-1, 1].each do |multiplier|
      x = ant1[0]
      y = ant1[1]

      # Extend line search
      loop do
        x += multiplier * dx
        y += multiplier * dy

        break unless valid_coordinate?(x, y)

        antinodes << [x, y] if inline?(ant1, ant2, [x, y])
      end
    end
  end

  def inline?(ant1, ant2, point)
    # Check if point is exactly in line with ant1 and ant2
    (ant2[0] - ant1[0]) * (point[1] - ant1[1]) ==
      (point[0] - ant1[0]) * (ant2[1] - ant1[1])
  end

  def valid_coordinate?(x, y)
    x >= 0 && x < @width && y >= 0 && y < @height
  end

  def count_antinodes
    calculate_antinodes.size
  end

  def print_map_with_antinodes
    antinodes = calculate_antinodes
    map_copy  = @map.map(&:chars)

    antinodes.each do |x, y|
      map_copy[y][x] = '#' if map_copy[y][x] == '.'
    end

    map_copy.map(&:join).join("\n")
  end
end

antenna_map = AntennaMap.new(helper.input)
puts antenna_map.count_antinodes
