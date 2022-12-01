require 'pry'

INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'

WINNING_LINES = [[1, 2, 3],
                 [4, 5, 6],
                 [7, 8, 9],
                 [1, 4, 7],
                 [2, 5, 8],
                 [3, 6, 9],
                 [1, 5, 9],
                 [3, 5, 7]]

def prompt(msg)
  puts "=> #{msg}"
end

def joinor(arr, punct = ', ', conjunction = 'or')
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

# rubocop: disable Metrics/AbcSize
def display_board(brd)
  # system 'clear'
  puts "You're #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}."
  puts ''
  puts "     |     |     "
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}  "
  puts "     |     |     "
  puts "-----+-----+-----"
  puts "     |     |     "
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}  "
  puts "     |     |     "
  puts "-----+-----+-----"
  puts "     |     |     "
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}  "
  puts "     |     |     "
  puts ''
end
# rubocop: enable Metrics/AbcSize

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def player_move(brd)
  square = ''
  loop do
    prompt "Choose a position to place a piece: #{joinor(empty_squares(brd))}"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "Invalid choice."
  end
  brd[square] = PLAYER_MARKER
end

def computer_move(brd)
  move = nil

  ["Computer", "Player"].each do |competitor|
    WINNING_LINES.each do |line|
      break if move
      move = winning_square(brd, line, competitor) # offense
    end
    break if move
  end  
  
  move = 5 if move == nil && brd[5] == INITIAL_MARKER
  move = empty_squares(brd).sample if move == nil
  p "Computer plays to square #{move}"
  brd[move] = COMPUTER_MARKER
end

def place_piece!(brd, competitor)
  if competitor == 'Player'
    player_move(brd)
  else
    computer_move(brd)
  end
end

def winning_square(brd, line, competitor)
  marker = (competitor == "Player" ? PLAYER_MARKER : COMPUTER_MARKER)
  if brd.values_at(*line).count(marker) == 2 &&
     brd.values_at(*line).count(INITIAL_MARKER) == 1
    return brd.select { |k, v| line.include?(k) && v == INITIAL_MARKER }.keys[0]
  end
  nil
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end
  nil
end

def someone_won?(brd)
  !!detect_winner(brd)
end

loop do
  player_wins = 0
  computer_wins = 0
  prompt "Who should go first? (p)layer, (c)omputer, or should I choose (r)andomly?"
  first_move = case gets.chomp.downcase[0]
          when 'p' then 'Player'
          when 'c' then 'Computer'
          when 'r' then ['Player', 'Computer'].sample
          else
            puts 'Invalid input! Choosing first player at random.'
            ['Player', 'Computer'].sample
          end
          
  loop do # tracks games to 5
    board = initialize_board
    display_board(board)
    current_player = first_move

    loop do # loop of moves until someone wins
      place_piece!(board, current_player)
      display_board(board)
      current_player = (current_player == 'Player' ? 'Computer' : 'Player')
      break if someone_won?(board) || board_full?(board)
    end

    if someone_won?(board)
      winner = detect_winner(board)
      prompt "#{winner} won!"
      if winner == 'Player'
        player_wins += 1
      else
        computer_wins += 1
      end
    else
      prompt "It's a tie!"
    end

    prompt "You've won #{player_wins} times."
    prompt "The computer has won #{computer_wins} times."
    break if player_wins >= 5 || computer_wins >= 5
    prompt "Next game!"
  end

  if player_wins >= 5
    prompt "You are the grand winner!"
  else
    prompt "Computer is the grand winner!"
  end
  prompt "Play again? (y or n)"
  answer = gets.chomp
  break unless answer.downcase[0] == 'y'
end

prompt "Goodbye!"
