flintstones = %w(Fred Barney Wilma Betty BamBam Pebbles)

# p flintstones.map{|el| el[0, 2]}.index("Be")
p flintstones.index {|el| el =~ /Be/} 