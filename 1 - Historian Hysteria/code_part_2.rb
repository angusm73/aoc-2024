ids = File.readlines('./1 - Historian Hysteria/input.tsv')

list1 = []
list2 = []

ids.each do |id|
  id1, id2 = id.split('   ')
  list1 << id1.chomp.to_i
  list2 << id2.chomp.to_i
end

similarity_scores = list1.map do |l1_id|
  list2_occurences = list2.count(l1_id)
  l1_id * list2_occurences
end

puts similarity_scores.sum
