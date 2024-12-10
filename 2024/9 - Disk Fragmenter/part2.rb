require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

class DiskCompactor
  attr_reader :disk_map, :blocks, :file_lengths

  def initialize(disk_map)
    @disk_map     = disk_map
    @file_lengths = parse_file_lengths(disk_map)
    @blocks       = parse_disk_map(disk_map)
  end

  def parse_file_lengths(map)
    map.chars.map(&:to_i).each_slice(2).to_a.map(&:first)
  end

  def parse_disk_map(map)
    blocks  = []
    file_id = 0
    map.chars.each_with_index do |length, idx|
      length.to_i.times do
        blocks << (idx.even? ? file_id : '.')
      end
      file_id += 1 if idx.even?
    end
    blocks
  end

  def compact
    # Move files in decreasing file ID order
    # blocks.each_with_index do |block, index|
    #   next unless block == '.'
    #   next if blocks[index - 1] == '.'
    #   next unless can_compact?
    #
    #   available_space = free_space_size(index)
    #   file_to_move    = file_lengths.rindex { |size| size <= available_space }
    #   # puts "#{index} has #{free_space_size(index)} - moving #{file_to_move}"
    #
    #   move_whole_file(file_to_move, index)
    # end
    # puts "- #{file_lengths}"
    (file_lengths.length - 1).downto(0) do |file_id|
      move_whole_file(file_id)
    end
  end

  def free_space_size(start_index)
    size  = 1
    index = start_index
    while blocks[index + 1] == '.'
      size  += 1
      index += 1
    end
    size
  end

  def move_whole_file(file_id)
    # Find the file's current position
    file_start = blocks.index(file_id)
    return if file_start.nil?

    file_length = file_lengths[file_id]

    # Extract the current file blocks
    current_file_blocks = blocks[file_start, file_length]

    # Calculate where this file can be moved
    free_space_start = nil
    blocks.each_with_index do |block, index|
      next unless block == '.'
      next if blocks[index - 1] == '.'

      available_space = free_space_size(index)
      if available_space >= file_length
        free_space_start = index
        break
      end
    end
    return if free_space_start.nil? || free_space_start >= file_start

    # Remove the file from its current location
    blocks[file_start, file_length] = Array.new(file_length, '.')

    # Place the file in the new location
    blocks[free_space_start, file_length] = current_file_blocks
  end

  def find_free_space_for_file(file_length)
    # Find the leftmost contiguous free space large enough for the file
    blocks.each_cons(file_length).with_index do |span, index|
      return index if span.all? { |block| block == '.' }
    end
    nil
  end

  def calculate_checksum
    blocks.each_with_index.sum do |block, position|
      block.is_a?(Integer) ? block * position : 0
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
