require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

class TowelMatcher
  def initialize(patterns)
    @patterns = patterns
    @memo     = {}
  end

  # Main method to count all possible ways to make a design
  def count_arrangements(design)
    @memo.clear # Clear memoization cache for each new design
    count_arrangements_at_position(design, 0)
  end

  private

  def count_arrangements_at_position(design, pos)
    # Base case: if we've reached the end of the design, we found one valid arrangement
    return 1 if pos == design.length

    # Check memoization cache
    memo_key = pos
    return @memo[memo_key] if @memo.key?(memo_key)

    total_arrangements = 0

    # Try each pattern at the current position
    @patterns.each do |pattern|
      # Skip if pattern is longer than remaining design
      next if pos + pattern.length > design.length

      # Check if pattern matches at current position
      matches = true
      pattern.each_char.with_index do |char, i|
        if char != design[pos + i]
          matches = false
          break
        end
      end

      # If pattern matches, recursively count arrangements for the rest
      if matches
        arrangements       = count_arrangements_at_position(design, pos + pattern.length)
        total_arrangements += arrangements
      end
    end

    # Cache and return the total arrangements possible from this position
    @memo[memo_key] = total_arrangements
    total_arrangements
  end
end

def solve_towel_combinations(input)
  # Split input into patterns and designs
  sections = input.split("\n\n")
  patterns = sections[0].split(', ')
  designs  = sections[1].split("\n")

  # Create matcher and sum all possible arrangements
  matcher = TowelMatcher.new(patterns)
  designs.sum do |design|
    arrangements = matcher.count_arrangements(design)
    arrangements
  end
end

puts solve_towel_combinations(helper.input)
