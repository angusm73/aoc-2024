require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

class LogicGateSimulator
  def initialize
    @wires = {}
    @gates = []
  end

  def parse_input(input)
    initial_values = true

    input.each_line do |line|
      line = line.strip
      next if line.empty?

      if line.include?('->')
        initial_values = false
        parse_gate(line)
      elsif initial_values
        parse_initial_value(line)
      end
    end
  end

  def parse_initial_value(line)
    wire, value  = line.split(':').map(&:strip)
    @wires[wire] = value.to_i
  end

  def parse_gate(line)
    inputs, output = line.split('->').map(&:strip)
    if inputs.include?('AND')
      input1, input2 = inputs.split('AND').map(&:strip)
      @gates << { type: :and, input1:, input2:, output: }
    elsif inputs.include?('XOR')
      input1, input2 = inputs.split('XOR').map(&:strip)
      @gates << { type: :xor, input1:, input2:, output: }
    elsif inputs.include?('OR')
      input1, input2 = inputs.split('OR').map(&:strip)
      @gates << { type: :or, input1:, input2:, output: }
    end
  end

  def evaluate_gate(gate)
    return if @wires.key?(gate[:output])

    input1_val = @wires[gate[:input1]]
    input2_val = @wires[gate[:input2]]

    return if input1_val.nil? || input2_val.nil?

    @wires[gate[:output]] = case gate[:type]
                            when :and
                              (input1_val & input2_val)
                            when :or
                              (input1_val | input2_val)
                            when :xor
                              (input1_val ^ input2_val)
                            else
                              return false
                            end

    true
  end

  def simulate
    until all_z_wires_present?
      # Try each gate multiple times until we can't make any more progress
      made_progress = true
      while made_progress
        made_progress = false
        @gates.each do |gate|
          made_progress = true if evaluate_gate(gate)
        end
      end

      # If we can't make progress and don't have all z wires, something's wrong
      unless made_progress || all_z_wires_present?
        raise "Unable to compute all z-wires. Current wires: #{@wires.inspect}"
      end
    end
  end

  def all_z_wires_present?
    z_wires = @gates.select { |gate| gate[:output].start_with?('z') }
    z_wires.all? { |gate| @wires.key?(gate[:output]) }
  end

  def calculate_result
    # Get all z-wires sorted by their numeric suffix
    z_wires = @wires.keys
                    .select { |wire| wire.start_with?('z') }
                    .sort

    # Convert to binary string and then to decimal
    binary = z_wires.map { |wire| @wires[wire].to_s }.reverse.join
    binary.to_i(2)
  end
end

simulator = LogicGateSimulator.new
simulator.parse_input(helper.input)
simulator.simulate
puts simulator.calculate_result
