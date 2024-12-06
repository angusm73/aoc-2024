require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

rules   = []
updates = []

helper.input_lines.each do |line|
  rules << line.chomp.split('|').map(&:to_i) if line.include?('|')
  updates << line.chomp.split(',').map(&:to_i) if line.include?(',')
end

def build_ordering_graph(rules)
  graph = Hash.new { |h, k| h[k] = Set.new }

  rules.each { |(before, after)| graph[before].add(after) }

  graph
end

def allowed?(pages, ordering_graph)
  pages.each_with_index do |page_num, index|
    pages[..index].each do |prev_page|
      if ordering_graph[page_num].include?(prev_page) &&
         pages.index(page_num) > pages.index(prev_page)
        return false
      end
    end

    true
  end
end

ordering_graph  = build_ordering_graph(rules)
allowed_updates = updates.filter { |update| allowed?(update, ordering_graph) }
middle_page_sum = allowed_updates.map { |update| update[update.length / 2] }.sum

puts middle_page_sum
