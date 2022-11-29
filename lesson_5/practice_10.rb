arr = [{a: 1}, {b: 2, c: 3}, {d: 4, e: 5, f: 6}]

new_arr = arr.map do |hash|
  hash.each_with_object({}) do |(key, val), result|
    result[key] = val + 1
  end
end

p new_arr