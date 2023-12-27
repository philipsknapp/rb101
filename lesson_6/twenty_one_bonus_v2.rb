HIGHEST_SCORE = 21

GAMES_TO_WIN = 5

RANKS = [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]

SUITS = [:clubs, :diamonds, :hearts, :spades]

SCORES_BY_RANK = { 2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6, 7 => 7, 8 => 8, 9 => 9,
          10 => 10, :jack => 10, :queen => 10, :king => 10, :ace => 1 }

# methods to take inputs and format outputs: get_player_input, pluralize,
# describe_array
def get_player_input(prompt, options)
  input = nil
  loop do
    puts prompt
    input = gets.chomp.downcase[0]
    break if options.include?(input)
    puts "Invalid input! Please choose #{describe_array(options, "or", "")}"
  end
  input
end

def pluralize(num)
  num == 1 ? "" : "s"
end

def describe_array(arr, conjunction = "and", article = "the ")
  description = ''
  case arr.length
  when 0 then description = ''
  when 1 then description = "#{article}#{arr[0].to_s}"
  when 2 then description = "#{article}#{arr[0]} #{conjunction} #{article}#{arr[1]}"
  else
    arr.each_with_index do |el, i|
      if i == arr.size - 1
        description << "#{conjunction} #{article}#{el}"
      else
        description << "#{article}#{el}, "
      end
    end
  end
  description
end

# methods to interact with arrays of cards: describe_open_hand, 
# describe_hidden_hand, score_hand
def describe_open_hand(cards)
  card_names = cards.map { |card| card[:name] }
  describe_array(card_names)
end

def describe_hidden_hand(cards)
  hidden = cards.length - 1
  "the #{cards[0][:name]} and #{hidden} unknown card#{pluralize(hidden)}"
end

def score_hand(hand)
  total = hand.map { |card| card[:score] }.sum
  hand.count{ |card| card[:rank] == :ace}.times do
      total += 10 if total + 10 <= HIGHEST_SCORE
    end
  total
end

# methods to create the deck and move cards around: initalize_deck, 
# generate_card, and deal_card
def generate_card(rank, suit)
  card = {}
  card[:rank] = rank
  card[:suit] = suit
  card[:score] = SCORES_BY_RANK[rank]
  card[:name] = rank.to_s.capitalize + ' of ' + suit.to_s.capitalize
  card
end

def initialize_deck
  deck = []
  SUITS.each do |suit|
    RANKS.each do |rank|
      deck << generate_card(rank, suit)
    end
  end
  deck.shuffle
end

def deal_card(cards)
  cards[:deck], cards[:discard] = cards[:discard], [] if cards[:deck].empty?
  cards[:deck].pop
end

# methods to facilitate the player's turn: show_discard, player_turn_start,
# player_turn_action. player_turn_start will branch to complete the entire
# inner gameplay loop.

def show_discard(cards)
  system 'clear'
  puts "The discard pile contains:"
  cards[:discard].each {|card| puts card[:name]}
  puts "Hit Enter to go back."
  gets
end


def player_turn_start(cards)
  player_score = score_hand(cards[:player])
  sleep 2
  puts <<~DESCRIBE_HANDS
      Dealer has: #{describe_hidden_hand(cards[:dealer])}
      You have: #{state_open_hand(cards[:player])}
      Your total is #{player_score}
      DESCRIBE_HANDS
  if player_score > HIGHEST_SCORE
    puts "You bust!"
    end_of_game(cards)
  else
    player_turn_action
  end
end

def player_turn_action(cards)
  player_choice = get_player_input("(h)it or (s)tay? Press (d) to check the discard pile", \
                                 %w(h s d))
  if player_choice == 'd'
    show_discard(cards)
    player_turn_start(cards)
  elsif player_choice == 'h'
    cards[:player] << deal_card(cards)
    player_turn_start(cards)
  elsif player_choice == 's'
    puts "You stay"
    dealer_turn(cards)
  end
end

# methods to facilitate the dealer's turn
def dealer_turn(cards)
  sleep 2
  puts "Dealer has: #{describe_hidden_hand(cards[:dealer])}"
  if dealer_score < HIGHEST_SCORE - 4
    puts "Dealer hits!"
    cards[:dealer] << deal_card(cards)
    dealer_score = score_hand(cards[:dealer])
  elsif dealer_score > HIGHEST_SCORE
    puts "Dealer busts!"
  else
    puts "Dealer stays"
  end
end
  

# methods to perform end-of-game calculation and output: ... 
def end_of_game(cards)
end

loop do
  system 'clear'
  puts <<~INTRO
  Welcome to #{HIGHEST_SCORE}!
  The first player to win #{GAMES_TO_WIN} games will be the grand winner. Ready?
  INTRO
  
  games_won = {player: 0, dealer: 0}
  cards = {deck: initialize_deck, discard: []}
  
  loop do
    sleep 2
    puts "New game!"
    puts "Dealing cards..."

    cards[:player] = []
    cards[:dealer] = []

    2.times do
      cards[:player] << deal_card(cards)
      cards[:dealer] << deal_card(cards)
    end
    
    dealer_score = score_hand(cards[:dealer])
    winner = nil
    
    player_turn_start(cards)
    

    
    sleep 2
    puts <<~ENDGAME_REVEAL_HANDS # end of game evaluation
      *** End of the game! ***
      You have: #{state_open_hand(cards[:player])}
      Your score is #{player_score}
      Dealer has: #{state_open_hand(cards[:dealer])}
      Their score is #{dealer_score}
    ENDGAME_REVEAL_HANDS

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

    sleep 5
    case winner
    when 'player'
      puts "You win!"
      games_won[:player] += 1
    when 'dealer'
      puts "Dealer wins!"
      games_won[:dealer] += 1
    else
      puts "Tie game!"
    end

    sleep 2
    puts <<~OVERALL_SCORE
      You have won #{games_won[:player]} game#{pluralize(games_won[:player])}
      The dealer has won #{games_won[:dealer]} game#{pluralize(games_won[:dealer])}
    OVERALL_SCORE
    
    cards[:discard] = cards[:discard] + cards[:player] + cards[:dealer]
    
    sleep 2
    if games_won[:player] >= GAMES_TO_WIN || games_won[:dealer] >= GAMES_TO_WIN
      puts "#{games_won[:player] >= GAMES_TO_WIN ? 'You are' : 'The dealer is'} the grand winner."
      puts "************************"
      break
    else
      puts "************************"
    end
    puts
  end

  sleep 1
  rematch = get_player_input("Another game? (y/n)", %w(y n))
  break unless rematch == 'y'
end

sleep 1
puts "Thanks for playing #{HIGHEST_SCORE}!"


=begin
refactored structure might look like
outer loop # initializes a set of games with a fresh deck and win count
  inner loop # plays out an individual game
    player move method
    dealer move method
    endgame methods:
      evaluate the winner
      display the winner
      adjust the win count
  end inner loop
declare grand winner
offer to play again
end outer loop
goodbye message

each of the inner loop methods only really needs access to cards to calculate
everything, since cards holds the entire gamestate. "adjust the win count" also
needs to access the win counts in the inner and outer loops
=end
