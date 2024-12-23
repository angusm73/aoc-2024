require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

class NetworkAnalyzer
  def initialize(connections)
    @connections = parse_connections(connections)
    @computers   = @connections.keys
  end

  def find_connected_triplets(filter_prefix: nil)
    triplets = []

    @computers.combination(3).each do |triplet|
      next unless fully_connected?(triplet)

      triplets << triplet.sort if !filter_prefix || triplet.any? { |computer| computer.start_with?(filter_prefix) }
    end

    triplets.uniq
  end

  private

  def parse_connections(input)
    connections = Hash.new { |h, k| h[k] = Set.new }

    input.each_line(chomp: true) do |line|
      next if line.empty?

      comp1, comp2 = line.split('-')
      connections[comp1] << comp2
      connections[comp2] << comp1
    end

    connections
  end

  def fully_connected?(computers)
    computers.all? do |comp1|
      computers.all? do |comp2|
        comp1 == comp2 || @connections[comp1].include?(comp2)
      end
    end
  end
end

analyzer = NetworkAnalyzer.new(helper.input)
triplets = analyzer.find_connected_triplets(filter_prefix: 't')
puts triplets.count
