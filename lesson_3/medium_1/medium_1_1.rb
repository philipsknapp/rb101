phrase = "The Flintstones Rock!" 
10.times do
  phrase.prepend(" ")
  # puts phrase
end # initial solution, didn't see that it needed to be one line


10.times { |num| puts (" " * num) + "The Flintstones Rock!" } 