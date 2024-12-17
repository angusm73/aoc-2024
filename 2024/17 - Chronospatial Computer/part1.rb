require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

class Computer
  attr_reader :reg_a, :reg_b, :reg_c, :program, :instruction_pointer

  def initialize(input)
    @reg_a, @reg_b, @reg_c = parse_registers(input)
    @program               = parse_program(input)
    @instruction_pointer   = 0
    @output                = []
  end

  def simulate
    while @instruction_pointer < program.size
      opcode, operand      = program.slice(instruction_pointer, 2)
      @instruction_pointer = run(opcode, operand)
    end
  end

  def output
    @output.join(',')
  end

  def to_s
    <<~COMPUTER
      Register A: #{reg_a}
      Register B: #{reg_b}
      Register C: #{reg_c}
      Program: #{program}
    COMPUTER
  end

  private

  def run(opcode, operand)
    new_pointer = instruction_pointer + 2

    case opcode
    when 0 # adv
      @reg_a = reg_a / (2**combo(operand))
    when 1 # bxl
      @reg_b = reg_b ^ operand
    when 2 # bst
      @reg_b = combo(operand) % 8
    when 3 # jnz
      (new_pointer = operand) unless reg_a.zero?
    when 4 # bxc
      @reg_b = reg_b ^ reg_c
    when 5 # out
      @output << combo(operand) % 8
    when 6 # bdv
      @reg_b = reg_a / (2**combo(operand))
    when 7 # cdv
      @reg_c = reg_a / (2**combo(operand))
    else ''
    end

    new_pointer
  rescue ZeroDivisionError => e
    puts e
    puts "Opcode: #{opcode}, operand: #{operand}"
    puts self
    exit 1
  end

  def combo(operand)
    case operand
    when 0..3
      operand
    when 4
      reg_a
    when 5
      reg_b
    when 6
      reg_c
    else
      raise "#{operand} is not a valid combo operand"
    end
  end

  def parse_registers(input)
    reg_values = []
    input.scan(/Register \S: (\d+)$/).each do |reg|
      reg_values << reg[0].to_i
    end
    reg_values
  end

  def parse_program(input)
    input.match(/Program: ([\d,]+)$/).to_a.last.split(',').map(&:to_i)
  end

end

computer = Computer.new(helper.input)
computer.simulate
puts computer.output
