require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

class LogicGateSimulator
  def initialize
    @wires = {}
    @gates = []
  end

  def parse_input(input)
    @highest_z = 'z00'
    input.each_line do |line|
      line = line.strip
      next if line.empty?

      next unless line.include?('->')

      inputs, output = line.split(' -> ')
      a, op, b       = inputs.split(' ')
      @gates << { a:, op:, b:, output: }

      @wires[a]      ||= nil
      @wires[b]      ||= nil
      @wires[output] ||= nil

      if (output[0] == 'z') && (output[1..].to_i > @highest_z[1..].to_i)
        @highest_z = output
      else
        name, value  = line.split(': ')
        @wires[name] = value.to_i
      end
    end
  end

  def solve
    wrong = Set.new
    @gates.each do |gate|
      wrong.add(gate[:output]) if gate[:output][0] == 'z' && gate[:op] != 'XOR' && gate[:output] != @highest_z
      if gate[:op] == 'XOR' && !%w[x y z].include?(gate[:output][0]) &&
         !%w[x y z].include?(gate[:a][0]) && !%w[x y z].include?(gate[:b][0])
        wrong.add(gate[:output])
      end
      if gate[:op] == 'AND' && ![gate[:a], gate[:b]].include?('x00')
        @gates.each do |sub_gate|
          wrong.add(gate[:output]) if [sub_gate[:a], sub_gate[:b]].include?(gate[:output]) && sub_gate[:op] != 'OR'
        end
      end
      next unless gate[:op] == 'XOR'

      @gates.each do |sub_gate|
        wrong.add(gate[:output]) if [sub_gate[:a], sub_gate[:b]].include?(gate[:output]) && sub_gate[:op] == 'OR'
      end
    end

    operations = @gates.dup

    until operations.empty?
      gate = operations.shift
      if @wires.key?(gate[:a]) && @wires.key?(gate[:b])
        @wires[gate[:output]] = process(gate)
      else
        operations.append(gate)
      end
    end

    wrong.sort.join(',')
  end

  def process(gate)
    case gate[:type]
    when :and
      gate[:a] & gate[:b]
    when :or
      gate[:a] | gate[:b]
    when :xor
      gate[:a] ^ gate[:b]
    end
  end
end

simulator = LogicGateSimulator.new
simulator.parse_input(helper.input)
puts simulator.solve

