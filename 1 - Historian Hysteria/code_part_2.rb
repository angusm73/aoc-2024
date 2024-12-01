ids = File.readlines('./1 - Historian Hysteria/input')

list1 = []
list2 = []

ids.each do |id|
  id1, id2 = id.split.map(&:to_i)
  list1 << id1
  list2 << id2
end

list2_counts = list2.tally

similarity_score = list1.sum do |num|
  num * (list2_counts[num] || 0)
end

puts similarity_score
