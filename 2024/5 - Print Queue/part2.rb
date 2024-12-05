input = File.readlines(File.join(File.dirname(__FILE__), './input'))

rules   = []
updates = []

input.each do |line|
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
      prev_index = pages.index(prev_page)
      if ordering_graph[page_num].include?(prev_page) &&
         index > prev_index
        return false
      end
    end

    true
  end
end

def fix_page_order(pages, ordering_graph)
  pages.each_with_index do |page_num, index|
    pages[..index].each do |prev_page|
      prev_index = pages.index(prev_page)
      if ordering_graph[page_num].include?(prev_page) &&
         index > prev_index
        pages[prev_index], pages[index] = pages[index], pages[prev_index]
      end
    end

    true
  end
end

ordering_graph    = build_ordering_graph(rules)
incorrect_updates = updates.reject { |update| allowed?(update, ordering_graph) }
corrected_updates = incorrect_updates.map { |update| fix_page_order(update, ordering_graph) }
middle_page_sum   = corrected_updates.map { |update| update[update.length / 2] }.sum

puts middle_page_sum
