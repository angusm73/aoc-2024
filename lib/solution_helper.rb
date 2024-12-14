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

  def demo?
    !!ENV['DEMO']
  end

  def real?
    !demo?
  end

  private

  def input_filename
    return File.join(solution_path, DEMO_INPUT_FILENAME) if demo?

    File.join(solution_path, INPUT_FILENAME)
  end

end
