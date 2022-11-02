advice = "Few things in life are as important as house training your pet dinosaur."

p advice.slice("Few things in life are as important as ") #my initial solution
p advice.slice!(0, advice.index('house'))
p advice