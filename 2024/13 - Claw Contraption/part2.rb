require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

class ClawMachineSolver
  PRIZE_OFFSET = 10_000_000_000_000

  def initialize(machines)
    @machines = parse(machines)
    @cache    = {}
  end

  def parse(input)
    input.split("\n\n").map do |machine|
      a_x, a_y         = parse_button('A', machine)
      b_x, b_y         = parse_button('B', machine)
      prize_x, prize_y = parse_prize(machine)

      {
        a_x:,
        a_y:,
        b_x:,
        b_y:,
        prize_x:,
        prize_y:
      }
    end
  end

  def parse_button(letter, machine)
    matches = machine.match(/Button #{letter}: X\+(\d+), Y\+(\d+)/)
    [matches[1].to_i, matches[2].to_i]
  end

  def parse_prize(machine)
    matches = machine.match(/Prize: X=(\d+), Y=(\d+)/)
    [matches[1].to_i + PRIZE_OFFSET, matches[2].to_i + PRIZE_OFFSET]
  end

  def solve
    @machines.sum do |machine|
      solution = solve_single_machine(
        machine[:a_x], machine[:a_y],
        machine[:b_x], machine[:b_y],
        machine[:prize_x], machine[:prize_y]
      )

      solution ? solution[:a_presses] * 3 + solution[:b_presses] : 0
    end
  end

  private

  def can_win_prize?(machine)
    solve_single_machine(machine[:a_x], machine[:a_y], machine[:b_x], machine[:b_y], machine[:prize_x], machine[:prize_y]) != nil
  end

  def solve_single_machine(a_x, a_y, b_x, b_y, prize_x, prize_y)
    return @cache[[a_x, a_y, b_x, b_y, prize_x, prize_y]] if @cache[[a_x, a_y, b_x, b_y, prize_x, prize_y]]

    # Solve system of linear equations:
    # a_x * m + b_x * n = prize_x
    # a_y * m + b_y * n = prize_y

    # Calculate determinant
    det = a_x * b_y - b_x * a_y

    return nil if det.zero? # No solution if determinant is 0

    # Calculate inverse matrix multiplied by prize coordinates
    m = (b_y * prize_x - b_x * prize_y).to_f / det
    n = (-a_y * prize_x + a_x * prize_y).to_f / det

    # Check if we have integer solutions
    return nil unless m == m.round && n == n.round

    m = m.to_i
    n = n.to_i

    return nil if m.negative? || n.negative? # Solutions must be positive

    @cache[[a_x, a_y, b_x, b_y, prize_x, prize_y]] = { a_presses: m, b_presses: n }
    { a_presses: m, b_presses: n }
  end
end

puts ClawMachineSolver.new(helper.input).solve
