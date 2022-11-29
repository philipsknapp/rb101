munsters = {
  "Herman" => { "age" => 32, "gender" => "male" },
  "Lily" => { "age" => 30, "gender" => "female" },
  "Grandpa" => { "age" => 402, "gender" => "male" },
  "Eddie" => { "age" => 10, "gender" => "male" },
  "Marilyn" => { "age" => 23, "gender" => "female"}
}

munsters.each do |key, val|
  age_group = case val["age"]
    when 0..17 then "kid"
    when 18..64 then "adult"
    else "senior"
  end
      
  val["age group"] = age_group
end

p munsters