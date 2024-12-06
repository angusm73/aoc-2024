# Helpers for writing solutions
class SolutionHelper
  INPUT_FILENAME      = 'input'.freeze
  DEMO_INPUT_FILENAME = 'demo'.freeze

  attr_accessor :solution_path

  def initialize(dir:)
    @solution_path = dir
  end

  def input
    File.read(input_filename)
  end

  def input_lines
    File.readlines(input_filename)
  end

  private

  def input_filename
    return File.join(solution_path, DEMO_INPUT_FILENAME) if ENV['DEMO']

    File.join(solution_path, INPUT_FILENAME)
  end

end
