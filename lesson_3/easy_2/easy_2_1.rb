ages = { "Herman" => 32, "Lily" => 30, "Grandpa" => 402, "Eddie" => 10 }

p ages.any? {|key, _| key == "Spot"}
p ages.assoc("Spot")
p ages.fetch("Spot", "Spot's not here!")
p ages.include?("Spot")
p ages.key?("Spot")