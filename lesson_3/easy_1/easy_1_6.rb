famous_words = "seven years ago..."

famous_words = "fourscore and " + famous_words
famous_words = "fourscore and #{famous_words}"
famous_words.prepend("fourscore and ")

p famous_words