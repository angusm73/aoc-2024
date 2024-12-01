ids = File.readlines('./1 - Historian Hysteria/input')

list1 = []
list2 = []

ids.each do |id|
  id1, id2 = id.split.map(&:to_i)
  list1 << id1
  list2 << id2
end

similarity_scores = list1.map do |l1_id|
  list2_occurrences = list2.count(l1_id)
  l1_id * list2_occurrences
end

puts similarity_scores.sum
