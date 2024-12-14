require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

class RobotGrid
  attr_accessor :robots

  def initialize(robots, rows, cols)
    @robots  = parse(robots)
    @rows    = rows
    @cols    = cols
    @mid_col = cols / 2
    @mid_row = rows / 2
  end

  def simulate
    robots.map!(&method(:move!))
  end

  def count_quadrants
    robots_in_quads = robots.reject do |robot|
      robot[:pos][0] == @mid_col || robot[:pos][1] == @mid_row
    end

    robots_in_quads.each_with_object([0, 0, 0, 0]) do |robot, counts|
      counts[quadrant(robot[:pos])] += 1
    end.reduce(:*)
  end

  def quadrant(pos)
    index = pos[1] < @mid_row ? 0 : 2
    index += 1 if pos[0] < @mid_col
    index
  end

  def visualize
    grid = Array.new(@rows) { Array.new(@cols, '.') }

    robots.each do |robot|
      x, y       = robot[:pos]
      grid[y][x] = 'x'
    end

    puts
    grid.each do |row|
      puts row.join('')
    end
    puts "\n"
  end

  private

  def parse(robots)
    robots.map do |line|
      match = line.match(/p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)/).to_a
      {
        pos: [match[1].to_i, match[2].to_i],
        vel: [match[3].to_i, match[4].to_i]
      }
    end
  end

  def move!(robot)
    robot[:pos][0] = (robot[:pos][0] + robot[:vel][0]) % @cols
    robot[:pos][1] = (robot[:pos][1] + robot[:vel][1]) % @rows
    robot
  end

end

cols = helper.demo? ? 11 : 101
rows = helper.demo? ? 7 : 103

grid = RobotGrid.new(helper.input_lines, rows, cols)
8000.times do |i|
  puts "Iteration #{i + 1}"
  grid.simulate
  grid.visualize
end
