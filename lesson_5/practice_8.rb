hsh = {first: ['the', 'quick'], second: ['brown', 'fox'], third: ['jumped'], fourth: ['over', 'the', 'lazy', 'dog']}

vowels = ''

hsh.each do |key, arr|
  arr.each do |word|
    word.chars.each do |char|
      vowels << char if char =~ /[aeiou]/
    end
  end
end

p vowels