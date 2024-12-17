require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

class Computer
  attr_reader :reg_a, :reg_b, :reg_c, :program, :instruction_pointer, :output

  def initialize(reg_a, reg_b, reg_c, program)
    @reg_a               = reg_a
    @reg_b               = reg_b
    @reg_c               = reg_c
    @program             = program
    @instruction_pointer = 0
    @output              = []
  end

  def simulate
    while @instruction_pointer < program.size
      opcode, operand      = program.slice(instruction_pointer, 2)
      @instruction_pointer = run(opcode, operand)
    end
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
        @reg_a = reg_a / (2 ** combo(operand))
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
        @reg_b = reg_a / (2 ** combo(operand))
      when 7 # cdv
        @reg_c = reg_a / (2 ** combo(operand))
      else
        ''
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

    def abort_if_wonky!
      return if target_output.nil? || @output.empty?

      # puts "machine not on track. actual: #{@output}, expected: #{target_output}"
      raise 'machine not on track' unless (@output & target_output).size == @output.size
    end

end

registers = []
helper.input.scan(/Register \S: (\d+)$/).each do |reg|
  registers << reg[0].to_i
end

target_program = helper.input.match(/Program: ([\d,]+)$/).to_a.last.split(',').map(&:to_i)

computer = Computer.new(*registers, target_program)
computer.simulate
puts "Expected output: #{target_program}"

def find_initial_a(registers, program, next_val = 0, i = 0)
  return next_val if i.negative?

  (next_val * 8..next_val * 8 + 7).each do |a_val|
    computer = Computer.new(a_val, registers[1], registers[2], program)
    computer.simulate

    if computer.output[0] == program[i]
      final_val = find_initial_a(registers, program, a_val, i - 1)
      return final_val if final_val >= 0
    end
  end

  -1
end

puts 'To have the program output itself, initialize register A to:'
puts find_initial_a(registers, target_program, 0, target_program.size - 1)
