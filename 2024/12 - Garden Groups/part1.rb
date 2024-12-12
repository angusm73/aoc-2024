require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

class GardenPlotPricer
  def initialize(map_input)
    @map     = map_input.split("\n").map(&:chars)
    @rows    = @map.length
    @cols    = @map[0].length
    @visited = Array.new(@rows) { Array.new(@cols, false) }
  end

  def calculate_total_price
    reset_visited
    regions = find_regions
    regions.sum { |region| calculate_region_price(region) }
  end

  private

  def reset_visited
    @visited = Array.new(@rows) { Array.new(@cols, false) }
  end

  def find_regions
    regions = []
    @rows.times do |r|
      @cols.times do |c|
        next if @visited[r][c] || @map[r][c] == '.'

        region = explore_region(r, c)
        regions << region
      end
    end
    regions
  end

  def explore_region(start_r, start_c)
    plant_type = @map[start_r][start_c]
    region     = {
      type: plant_type,
      plots: [],
      area: 0
    }

    queue = [[start_r, start_c]]

    until queue.empty?
      r, c = queue.shift

      # Skip if out of bounds, already visited, or different plant type
      next if r.negative? || r >= @rows ||
              c.negative? || c >= @cols ||
              @visited[r][c] ||
              @map[r][c] != plant_type

      @visited[r][c] = true
      region[:plots] << [r, c]
      region[:area] += 1

      # Explore adjacent cells
      [[0, 1], [0, -1], [1, 0], [-1, 0]].each do |dr, dc|
        queue << [r + dr, c + dc]
      end
    end

    region
  end

  def calculate_region_price(region)
    # Calculate perimeter by checking adjacent sides
    perimeter = region[:plots].sum do |r, c|
      # Check all 4 sides, count sides exposed to different types or edge
      [[0, 1], [0, -1], [1, 0], [-1, 0]].count do |dr, dc|
        nr = r + dr
        nc = c + dc
        # Perimeter side if:
        # 1. Outside map bounds
        # 2. Different plant type
        # 3. No plot at that location
        nr.negative? || nr >= @rows ||
          nc.negative? || nc >= @cols ||
          @map[nr][nc] != region[:type]
      end
    end

    region[:area] * perimeter
  end
end

pricer = GardenPlotPricer.new(helper.input)
puts pricer.calculate_total_price
