arr = [['b', 'c', 'a'], [2, 1, 3], ['blue', 'black', 'green']]

new_arr = arr.map do |subarr|
  subarr.sort {|val1, val2| val2 <=> val1}
end

p arr
p new_arr