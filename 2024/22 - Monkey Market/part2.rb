require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

class MonkeySecretSimulator
  attr_reader :secret, :values, :changes

  def initialize(secret)
    @secret = secret.to_i
  end

  def step
    # multiply the secret number by 64. Then, mix this result into the secret number. Finally, prune the secret number
    @secret = prune(mix(secret * 64))
    # divide the secret number by 32. Round the result down to the nearest integer.
    # Then, mix this result into the secret number. Finally, prune the secret number
    @secret = prune(mix((secret / 32).floor))
    # multiply the secret number by 2048. Then, mix this result into the secret number. Finally, prune the secret number
    @secret = prune(mix(secret * 2048))
    real_price(secret)
  end

  def mix(value)
    value ^ secret
  end

  def prune(number)
    number % 16_777_216
  end

  private

  def real_price(value)
    value % 10
  end
end

changes_map = Hash.new { |h, k| h[k] = {} }

helper.input_lines.each do |secret|
  rolling_diffs = []
  simulator     = MonkeySecretSimulator.new(secret)
  price         = simulator.step

  2000.times do
    new_price  = simulator.step
    price_diff = new_price - price

    # Maintain rolling buffer of 4 items
    rolling_diffs << price_diff
    rolling_diffs.shift if rolling_diffs.size > 4

    if rolling_diffs.size == 4
      frozen_diffs = rolling_diffs.dup

      # Only store the first occurrence for each secret
      changes_map[frozen_diffs][secret] = new_price unless changes_map[frozen_diffs].key?(secret)
    end

    price = new_price
  end
end

puts changes_map.values.map { |hash| hash.values.sum }.max
