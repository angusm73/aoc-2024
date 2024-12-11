require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

class StoneLine
  attr_reader :stones

  def initialize(stones)
    @stones = stones.split.map(&:to_i)
  end

  def blinks(number)
    number.times { blink }
    self
  end

  def blink
    @stones = stones.flat_map(&method(:handle))
    self
  end

  def count
    stones.size
  end

  def to_s
    stones.to_s
  end

  private

  def handle(stone)
    str = stone.to_s
    return [1] if stone.zero?
    return [str[..str.size / 2 - 1].to_i, str[str.size / 2..].to_i] if str.chars.size.even?

    [stone * 2024]
  end

end

stone_line = StoneLine.new(helper.input)
puts stone_line.blinks(25).count
