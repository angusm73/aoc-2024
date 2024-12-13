require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

class GardenPlotPricer
  DIRECTIONS = [[0, 1], [1, 0], [0, -1], [-1, 0]].freeze

  DEBUG = false

  def initialize(map_input)
    @map     = map_input.split("\n").map(&:chars)
    @rows    = @map.length
    @cols    = @map[0].length
    @visited = Array.new(@rows) { Array.new(@cols, false) }
  end

  def calculate_total_price
    total_price  = 0
    region_count = 0

    @rows.times do |row|
      @cols.times do |col|
        next if @visited[row][col]

        region_count += 1
        puts "\nProcessing Region ##{region_count} starting at [#{row},#{col}]" if DEBUG

        # For each unvisited plant, find its region and calculate price
        region_type  = @map[row][col]
        region_cells = Set.new

        # First BFS to find all cells in the region
        queue              = [[row, col]]
        @visited[row][col] = true

        until queue.empty?
          curr_pos = queue.shift
          region_cells.add(curr_pos)

          DIRECTIONS.each do |d_row, d_col|
            new_row = curr_pos[0] + d_row
            new_col = curr_pos[1] + d_col

            next unless in_bounds?(new_row, new_col)
            next if @visited[new_row][new_col]
            next unless @map[new_row][new_col] == region_type

            queue << [new_row, new_col]
            @visited[new_row][new_col] = true
          end
        end

        puts "  Region type: #{region_type}" if DEBUG
        puts "  Region size: #{region_cells.size}" if DEBUG

        # Find the bounding box
        min_row = region_cells.map(&:first).min
        max_row = region_cells.map(&:first).max
        min_col = region_cells.map(&:last).min
        max_col = region_cells.map(&:last).max

        # Count continuous sides
        sides = 0

        # Check horizontal edges (top)
        (min_row..max_row).each do |r|
          current_col = min_col
          while current_col <= max_col
            if region_cells.include?([r, current_col])
              # Start a new horizontal segment
              start_col = current_col

              # Find the end of this segment
              while current_col + 1 <= max_col &&
                    region_cells.include?([r, current_col + 1]) &&
                    # Only continue if the pattern above remains the same
                    (!region_cells.include?([r - 1, current_col + 1]) == !region_cells.include?([r - 1, current_col]))
                current_col += 1
              end

              # Check if there's a gap above this segment
              if (start_col..current_col).any? { |c| !region_cells.include?([r - 1, c]) }
                sides += 1
                puts "  Found top edge at row #{r}, cols #{start_col}..#{current_col}" if DEBUG
              end
            end
            current_col += 1
          end

          # Check horizontal edges (bottom)
          current_col = min_col
          while current_col <= max_col
            if region_cells.include?([r, current_col])
              # Start a new horizontal segment
              start_col = current_col

              # Find the end of this segment
              while current_col + 1 <= max_col &&
                    region_cells.include?([r, current_col + 1]) &&
                    # Only continue if the pattern below remains the same
                    (!region_cells.include?([r + 1, current_col + 1]) == !region_cells.include?([r + 1, current_col]))
                current_col += 1
              end

              # Check if there's a gap below this segment
              if (start_col..current_col).any? { |c| !region_cells.include?([r + 1, c]) }
                sides += 1
                puts "  Found bottom edge at row #{r}, cols #{start_col}..#{current_col}" if DEBUG
              end
            end
            current_col += 1
          end
        end

        # Check vertical edges (left)
        (min_col..max_col).each do |c|
          current_row = min_row
          while current_row <= max_row
            if region_cells.include?([current_row, c])
              # Start a new vertical segment
              start_row = current_row

              # Find the end of this segment
              while current_row + 1 <= max_row &&
                    region_cells.include?([current_row + 1, c]) &&
                    # For left edges, only break if there's a change in the left gap pattern
                    (!region_cells.include?([current_row + 1, c - 1]) == !region_cells.include?([current_row, c - 1]))
                current_row += 1
              end

              # Check if there's a gap to the left of this segment
              if (start_row..current_row).any? { |r| !region_cells.include?([r, c - 1]) }
                sides += 1
                puts "  Found left edge at col #{c}, rows #{start_row}..#{current_row}" if DEBUG
              end

            end
            current_row += 1
          end

          # Check vertical edges (right)
          current_row = min_row
          while current_row <= max_row
            if region_cells.include?([current_row, c])
              # Start a new vertical segment
              start_row = current_row

              # Find the end of this segment
              while current_row + 1 <= max_row &&
                    region_cells.include?([current_row + 1, c]) &&
                    # For right edges, break at any change in pattern
                    (!region_cells.include?([current_row + 1, c + 1]) == !region_cells.include?([current_row, c + 1]))
                current_row += 1
              end

              # Check if there's a gap to the right of this segment
              if (start_row..current_row).any? { |r| !region_cells.include?([r, c + 1]) }
                sides += 1
                puts "  Found right edge at col #{c}, rows #{start_row}..#{current_row}" if DEBUG
              end

            end
            current_row += 1
          end
        end

        puts "  Total sides: #{sides}" if DEBUG

        region_price = region_cells.size * sides
        puts "  Region price: #{region_cells.size} * #{sides} = #{region_price}" if DEBUG

        total_price += region_price
        puts "  Running total: #{total_price}" if DEBUG
      end
    end
    puts "\nFinal total: #{total_price}" if DEBUG
    total_price
  end

  private

  def in_bounds?(row, col)
    row >= 0 && row < @rows && col >= 0 && col < @cols
  end

end

pricer = GardenPlotPricer.new(helper.input)
puts pricer.calculate_total_price
