SCORE = { 2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6, 7 => 7, 8 => 8, 9 => 9,
          10 => 10, :jack => 10, :queen => 10, :king => 10, :ace => 1 }

VERBAL = { 2 => '2', 3 => '3', 4 => '4', 5 => '5', 6 => '6', 7 => '7',
           8 => '8', 9 => '9', 10 => '10', :jack => 'Jack', :queen => 'Queen',
           :king => 'King', :ace => 'Ace' }

def joinor(arr, punct = ', ', conjunction = 'or')
  arr = arr.map { |value| VERBAL[value] }
  speech = ''
  case arr.length
  when 0 then speech = ''
  when 1 then speech = arr[0].to_s
  when 2 then speech = "#{arr[0]} #{conjunction} #{arr[1]}"
  else
    arr.each_with_index do |el, i|
      speech << (i == arr.size - 1 ? "#{conjunction} #{el}" : "#{el}#{punct}")
    end
  end
  speech
end

def initialize_deck
  deck = []
  (2..10).each do |value|
    4.times { deck << value }
  end
  [:jack, :queen, :king, :ace].each do |value|
    4.times { deck << value }
  end
  deck.shuffle
end

def score_hand(hand)
  total = hand.map { |card| SCORE[card] }.sum
  hand.count(:ace).times { total += 10 if total + 10 <= 21 }
  total
end

def declare_winner(winner)
  if winner == "player"
    puts "You win!"
  elsif winner == "dealer"
    puts "Dealer wins!"
  else
    puts "Tie game!"
  end
end

deck = initialize_deck

player_cards = []
dealer_cards = []

2.times do
  player_cards << deck.pop
  dealer_cards << deck.pop
end

winner = nil

loop do
  # player turn: hit or stay
  system 'clear'
  print "Dealer has: #{VERBAL[dealer_cards[0]]} and "
  puts "#{dealer_cards.length - 1} unknown card"
  puts "You have: #{joinor(player_cards, ', ', 'and')}"

  player_score = score_hand(player_cards)

  puts "Your total is #{player_score}"

  if player_score > 21
    puts "You bust!"
    winner = "dealer"
    break
  end

  choice = nil
  loop do
    puts "(h)it or (s)tay?"
    choice = gets.chomp.downcase[0]
    break if ['h', 's'].include?(choice)
    puts "Invalid input! Please input h to hit or s to stay"
  end

  if choice == 'h'
    player_cards << deck.pop
  else
    puts "You stay"
    break
  end
end

loop do
  # dealer turn: hit or stay. Repeat until total >= 17
  break if winner
  system 'clear'
  print "Dealer has: #{VERBAL[dealer_cards[0]]} and "
  puts "#{dealer_cards.length - 1} unknown card"
  dealer_score = score_hand(dealer_cards)
  if dealer_score < 17
    puts "Dealer hits!"
    dealer_cards << deck.pop
  elsif dealer_score > 21
    puts "Dealer busts!"
    winner = "player"
    break
  else
    puts "Dealer stays"
    break
  end
end

unless winner
  puts
  puts "You have: #{joinor(player_cards, ', ', 'and')}"
  puts "Your score is #{score_hand(player_cards)}"
  puts "Dealer has: #{joinor(dealer_cards, ', ', 'and')}"
  puts "Their score is #{score_hand(dealer_cards)}"
  case score_hand(player_cards) <=> score_hand(dealer_cards)
  when 1
    winner = "player"
  when 0
    winner = "tie"
  when -1
    winner = "dealer"
  end
end

declare_winner(winner)
