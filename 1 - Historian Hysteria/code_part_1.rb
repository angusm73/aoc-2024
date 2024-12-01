ids = File.readlines('./1 - Historian Hysteria/input.tsv')

list1 = []
list2 = []

ids.each do |id|
  id1, id2 = id.split('   ')
  list1 << id1.chomp.to_i
  list2 << id2.chomp.to_i
end

list1.sort!
list2.sort!

distances = list1.map.with_index do |l1_id, i|
  l2_id = list2[i]
  (l1_id - l2_id).abs
end

puts distances.sum
