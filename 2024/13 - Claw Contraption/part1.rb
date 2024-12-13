require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

class ClawMachineSolver
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
    [matches[1].to_i, matches[2].to_i]
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

    # Try all combinations of A and B presses up to 100 each
    (0..100).each do |a_presses|
      (0..100).each do |b_presses|
        x_pos = a_x * a_presses + b_x * b_presses
        y_pos = a_y * a_presses + b_y * b_presses

        next unless x_pos == prize_x && y_pos == prize_y

        puts 'Found solution for machine:'
        puts "  A presses: #{a_presses} (cost: #{a_presses * 3})"
        puts "  B presses: #{b_presses} (cost: #{b_presses})"
        puts "  Total cost: #{a_presses * 3 + b_presses}"
        puts "  Target: (#{prize_x}, #{prize_y})"
        puts

        @cache[[a_x, a_y, b_x, b_y, prize_x, prize_y]] = { a_presses:, b_presses: }

        return { a_presses:, b_presses: }
      end
    end

    nil
  end
end

puts ClawMachineSolver.new(helper.input).solve
