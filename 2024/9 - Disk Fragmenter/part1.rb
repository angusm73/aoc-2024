require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

class DiskCompactor
  attr_reader :disk_map, :blocks

  def initialize(disk_map)
    @disk_map = disk_map
    @blocks   = parse_disk_map(disk_map)
  end

  def parse_disk_map(map)
    blocks  = []
    file_id = 0
    map.scan(/\d/).each_with_index do |length, idx|
      length.to_i.times do
        blocks << (idx.even? ? file_id : '.')
      end
      file_id += 1 if idx.even?
    end
    blocks
  end

  def compact
    move_files while can_compact?
  end

  def can_compact?
    leftmost_empty_idx   = blocks.index('.')
    rightmost_filled_idx = blocks.rindex { |b| b != '.' }
    leftmost_empty_idx < rightmost_filled_idx
  end

  def move_files
    # Find the rightmost file that can move
    rightmost_movable_file_idx = blocks.rindex { |b| b != '.' }
    return if rightmost_movable_file_idx.nil?

    current_file = blocks[rightmost_movable_file_idx]

    # Find the leftmost empty space
    leftmost_empty_idx = blocks.index('.')

    # Swap the file with the empty space, moving it left
    blocks[rightmost_movable_file_idx] = '.'
    blocks[leftmost_empty_idx]         = current_file
  end

  def calculate_checksum
    blocks.each_with_index.sum do |block, position|
      block == '.' ? 0 : block * position
    end
  end

  def to_s
    blocks.join
  end
end

def solve(input)
  compactor = DiskCompactor.new(input)
  compactor.compact
  compactor.calculate_checksum
end

puts solve(helper.input)
