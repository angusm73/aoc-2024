ids = File.readlines(File.join(File.dirname(__FILE__), './input'))

list1 = []
list2 = []

ids.each do |id|
  id1, id2 = id.split.map(&:to_i)
  list1 << id1
  list2 << id2
end

list1.sort!
list2.sort!

distances = list1.map.with_index do |l1_id, i|
  l2_id = list2[i]
  (l1_id - l2_id).abs
end

puts distances.sum