require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

class Graph
  attr_accessor :adj_list

  def initialize
    @adj_list = {}
  end

  def add_node(node)
    @adj_list[node] ||= []
  end

  def add_edge(node1, node2)
    add_node(node1)
    add_node(node2)
    @adj_list[node1] << node2 unless @adj_list[node1].include?(node2)
    @adj_list[node2] << node1 unless @adj_list[node2].include?(node1)
  end

  # Bron-Kerbosch algorithm to find maximal cliques
  def find_maximal_cliques
    all_cliques = []

    # Initialize Bron-Kerbosch with empty R, all nodes in P, and empty X
    bron_kerbosch([], @adj_list.keys.to_set, Set.new, all_cliques, @adj_list)
    all_cliques
  end

  private

  # Recursive Bron-Kerbosch implementation
  def bron_kerbosch(r, p, x, all_cliques, adj_list)
    if p.empty? && x.empty?
      all_cliques << r.dup
      return
    end

    p.each do |node|
      new_r = r + [node]
      new_p = p & adj_list[node] # Intersection of neighbors and p
      new_x = x & adj_list[node] # Intersection of neighbors and x
      bron_kerbosch(new_r, new_p, new_x, all_cliques, adj_list)
      p.delete(node)
      x.add(node)
    end
  end
end

class NetworkAnalyzer
  def initialize(connections)
    @graph = Graph.new
    parse_connections(connections)
  end

  def find_largest_clique
    @graph.find_maximal_cliques.min_by { |c| -c.size }
  end

  def get_lan_party_password
    find_largest_clique.sort.join(',')
  end

  private

  def parse_connections(input)
    input.each_line(chomp: true) do |line|
      next if line.empty?

      comp1, comp2 = line.split('-')
      @graph.add_edge(comp1, comp2)
    end
  end
end

analyzer = NetworkAnalyzer.new(helper.input)
puts analyzer.get_lan_party_password
