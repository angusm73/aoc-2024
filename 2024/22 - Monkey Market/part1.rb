require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

class MonkeySecretSimulator
  attr_reader :secret

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
  end

  def mix(value)
    value ^ secret
  end

  def prune(number)
    number % 16_777_216
  end
end

sum = helper.input_lines.sum do |line|
  simulator = MonkeySecretSimulator.new(line)
  2000.times { simulator.step }
  simulator.secret
end

puts sum
