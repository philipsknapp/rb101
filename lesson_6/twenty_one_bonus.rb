HIGHEST_SCORE = 21

SCORE = { 2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6, 7 => 7, 8 => 8, 9 => 9,
          10 => 10, :jack => 10, :queen => 10, :king => 10, :ace => 1 }

VERBAL = { 2 => '2', 3 => '3', 4 => '4', 5 => '5', 6 => '6', 7 => '7',
           8 => '8', 9 => '9', 10 => '10', :jack => 'Jack', :queen => 'Queen',
           :king => 'King', :ace => 'Ace' }

def get_char_input(message, chars)
  input = nil
  loop do
    puts message
    input = gets.chomp.downcase[0]
    break if chars.include?(input)
    puts "Invalid input! Please choose #{verbal_list(chars)}"
  end
  input
end

def pluralize(num)
  num == 1 ? "" : "s"
end

def verbal_list(arr)
  speech = ''
  case arr.length
  when 0 then speech = ''
  when 1 then speech = arr[0].to_s
  when 2 then speech = "#{arr[0]} and #{arr[1]}"
  else
    arr.each_with_index do |el, i|
      speech << (i == arr.size - 1 ? "and #{el}" : "#{el}, ")
    end
  end
  speech
end

def state_open_hand(cards)
  card_names = cards.map { |value| VERBAL[value] }
  verbal_list(card_names)
end

def state_hidden_hand(cards)
  hidden = cards.length - 1
  "#{VERBAL[cards[0]]} and #{hidden} unknown card#{pluralize(hidden)}"
end

def score_hand(hand)
  total = hand.map { |card| SCORE[card] }.sum
  hand.count(:ace).times { total += 10 if total + 10 <= HIGHEST_SCORE }
  total
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

loop do
  system 'clear'
  puts "Welcome to #{HIGHEST_SCORE}!"
  player_wins = 0
  dealer_wins = 0

  loop do
    puts "New game!"

    deck = initialize_deck

    player_cards = []
    dealer_cards = []

    2.times do
      player_cards << deck.pop
      dealer_cards << deck.pop
    end

    player_score = score_hand(player_cards)
    dealer_score = score_hand(dealer_cards)
    winner = nil

    loop do # player turn
      puts "Dealer has #{state_hidden_hand(dealer_cards)}"
      puts "You have: #{state_open_hand(player_cards)}"
      puts "Your total is #{player_score}"

      if player_score > HIGHEST_SCORE
        puts "You bust!"
        winner = "dealer"
        break
      end

      hit_stay = get_char_input("(h)it or (s)tay?", %w(h s))

      if hit_stay == 'h'
        player_cards << deck.pop
        player_score = score_hand(player_cards)
      else
        puts "You stay"
        break
      end
    end

    loop do # dealer turn
      break if winner # if the player hbust, go directly to end of game eval
      puts "Dealer has: #{state_hidden_hand(dealer_cards)}"
      if dealer_score < HIGHEST_SCORE - 4
        puts "Dealer hits!"
        dealer_cards << deck.pop
        dealer_score = score_hand(dealer_cards)
      elsif dealer_score > HIGHEST_SCORE
        puts "Dealer busts!"
        winner = "player"
        break
      else
        puts "Dealer stays"
        break
      end
    end

    puts # end of game evaluation
    puts "*** End of the game! ***"
    puts "You have: #{state_open_hand(player_cards)}"
    puts "Your score is #{player_score}"
    puts "Dealer has: #{state_open_hand(dealer_cards)}"
    puts "Their score is #{dealer_score}"

    unless winner # compare hands only if neither party bust
      case player_score <=> dealer_score
      when 1
        winner = 'player'
      when 0
        winner = 'tie'
      when -1
        winner = 'dealer'
      end
    end

    case winner
    when 'player'
      puts "You win!"
      player_wins += 1
    when 'dealer'
      puts "Dealer wins!"
      dealer_wins += 1
    else
      puts "Tie game!"
    end

    puts "You have won #{player_wins} game#{pluralize(player_wins)}"
    puts "The dealer has won #{dealer_wins} game#{pluralize(dealer_wins)}"

    if player_wins >= 5 || dealer_wins >= 5
      puts "#{player_wins >= 5 ? 'You are' : 'The dealer is'} the grand winner."
      puts "************************"
      break
    else
      puts "************************"
    end
    puts
  end

  rematch = get_char_input("Another game? (y/n)", %w(y n))
  break unless rematch == 'y'
end

puts "Thanks for playing #{HIGHEST_SCORE}!"
