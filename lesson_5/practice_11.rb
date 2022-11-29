arr = [[2], [3, 5, 7, 12], [9], [11, 13, 15]]

new = arr.map do |subarr|
  subarr.select { |num| num % 3 == 0 }
end

p new