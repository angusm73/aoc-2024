require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

class TowelMatcher
  def initialize(patterns)
    @patterns = patterns
    @memo     = {}
  end

  # Main method to check if a design is possible
  def can_make_design?(design)
    @memo.clear
    can_split_at_position?(design, 0)
  end

  private

  def can_split_at_position?(design, pos)
    # Base case: if we've reached the end of the design, it's possible
    return true if pos == design.length

    # Check memoization cache
    memo_key = pos
    return @memo[memo_key] if @memo.key?(memo_key)

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

      next unless matches

      # If pattern matches, recursively try to match the rest
      if can_split_at_position?(design, pos + pattern.length)
        @memo[memo_key] = true
        return true
      end
    end

    # If no pattern works, this position is impossible
    @memo[memo_key] = false
    false
  end
end

# Parse input and solve the problem
def solve_towel_problem(input)
  # Split input into patterns and designs
  sections = input.split("\n\n")
  patterns = sections[0].split(', ')
  designs  = sections[1].split("\n")

  # Create matcher and count possible designs
  matcher = TowelMatcher.new(patterns)
  designs.count { |design| matcher.can_make_design?(design) }
end

puts solve_towel_problem(helper.input)
