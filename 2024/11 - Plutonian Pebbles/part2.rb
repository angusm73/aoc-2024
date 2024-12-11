require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

class StoneLine
  attr_reader :stones, :cache

  def initialize(stones)
    @stones = stones.split.map(&:to_i).tally
    @cache  = {}
  end

  def blinks(number)
    number.times { blink }
    self
  end

  def blink
    new_stones = stones.dup
    stones.each do |stone, amount|
      first, second = cached_handle(stone)
      new_stones[stone] -= amount
      new_stones[first] ||= 0
      new_stones[first] += amount
      if second
        new_stones[second] ||= 0
        new_stones[second] += amount
      end
    end
    @stones = new_stones
    self
  end

  def count
    stones.values.sum
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

  def cached_handle(stone)
    return cache[stone] if cache.key?(stone)

    handle(stone).tap do |result|
      cache[stone] = result
    end
  end

end

stone_line = StoneLine.new(helper.input)
puts stone_line.blinks(75).count
