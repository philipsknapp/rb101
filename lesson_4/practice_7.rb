statement = "The Flintstones Rock"
statement_freqs = Hash.new(0)

statement.chars.select{|char| char =~ /[A-Za-z]/}.each {|char| statement_freqs[char] += 1}

p statement_freqs