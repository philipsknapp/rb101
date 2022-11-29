=begin
We want to build a single player Tic Tac Toe game
where a user can play against the computer.

1. Display the initial empty 3x3 board.
2. Ask the user to mark a square.
3. Computer marks a square.
4. Display the updated board state.
5. If winner, display winner.
6. If board is full, display tie.
7. If neither winner nor board is full, go to #2
8. Play again?
9. If yes, go to #1
10. Good bye!

=end

INPUT_NUMS = [['7', '8', '9'],
              ['4', '5', '6'],
              ['1', '2', '3']]
INPUT_MAPPING = {
  '7' => [0, 0],
  '8' => [0, 1],
  '9' => [0, 2],
  '4' => [1, 0],
  '5' => [1, 1],
  '6' => [1, 2],
  '1' => [2, 0],
  '2' => [2, 1],
  '3' => [2, 2]
}

# method to display board - may want an argument to display with input numbers
def display_row(board, row, inputs = false)
  print_row = board[row].clone
  if inputs
    0.upto(board[row].length - 1) do |col|
      print_row[col] = INPUT_NUMS[row][col] if print_row[col] == ' '
    end
  end
  puts " #{print_row[0]} | #{print_row[1]} | #{print_row[2]} "
end

def display_board(board, inputs = false)
  puts
  display_row(board, 0, inputs)
  puts '-----------'
  display_row(board, 1, inputs)
  puts '-----------'
  display_row(board, 2, inputs)
  puts
end

# method to take & verify user inputs

def get_input(board)
  input = 0
  loop do
    puts "Please choose your next square!"
    puts "Type the corresponding number below:"
    display_board(board, true)
    input = gets.chomp
    unless (input.to_i.to_s == input) && (1..9).include?(input.to_i)
      puts "Please enter an integer 1-9!"
      next
    end # first check to ensure valid integer
    row, col = INPUT_MAPPING[input]
    if board[row][col] != ' '
      puts 'That space is already occupied! Try again.'
      next
    end
    break
  end
  input
end

# method for computer to mark a square at random - could soup this up into
# a full AI algorithm as a separate coding task
def computer_move_random(board)
  # rule out marked squares - step through each row & column on the board and
  # construct an array of arrays of all open squares
  open_moves = []
  (0...board.length).each do |row|
    (0...board[row].length).each do |column|
      open_moves << [row, column] if board[row][column] == ' '
    end
  end
  chosen_row, chosen_col = open_moves.sample
  board[chosen_row][chosen_col] = 'O'
end

def horiz_wins?(board, char)
  board.each do |row|
    return true if row.all?(char)
  end
  false
end

def vert_wins?(board, char, size)
  columns = []
  (0...size).each do |column| # assemble columns - 1 val from each row
    single_column = []
    (0...size).each do |row|
      single_column << board[row][column]
    end
    columns << single_column
  end
  columns.each do |column|
    return true if column.all?(char)
  end
  false
end

def diag_wins?(board, char, size)
  diag1to9 = []
  diag7to3 = []
  (0...size).each do |position|
    diag1to9 << board[position][position]
    diag7to3 << board[position][(size - 1) - position]
  end
  return true if diag1to9.all?(char) || diag7to3.all?(char)
  false
end

# method to check for a winner
def winner?(board, char)
  win = false
  size = board.length
  win = true if horiz_wins?(board, char) # check for horizontal wins
  win = true if vert_wins?(board, char, size) # check for vertical wins
  win = true if diag_wins?(board, char, size) # check for diagonal wins
  win
end

# method to check for a tie
def tie?(board)
  board.flatten.all? { |char| char != ' ' }
end

loop do # main game loop
  puts "Welcome to Tic Tac Toe! Here's the empty board!"
  # initialize data structure to hold board state
  board = [[' ', ' ', ' '],
           [' ', ' ', ' '],
           [' ', ' ', ' ']]
  # display board
  display_board(board)
  loop do # turn loop
    # user marks square
    input = get_input(board)
    row, col = INPUT_MAPPING[input]
    board[row][col] = 'X'
    puts "Here's your move:"
    display_board(board)
    # check for winner or tie - because player goes first, tie will
    # always occur after player moves on a 3 x 3 board
    if winner?(board, 'X')
      puts "You win!"
      break
    elsif tie?(board)
      puts "Tie game!"
      break
    end
    # computer goes
    computer_move_random(board)
    puts "Now, my move!"
    display_board(board)
    # check again for winner or tie (check for tie in case of n x n board)
    if winner?(board, 'O')
      puts "Computer wins!"
      break
    elsif tie?(board)
      puts "Tie game!"
      break
    end
  end
  puts "Care for another game? (y/n)"
  break unless gets.chomp.downcase[0] == 'y'
  # if yes, loop back to start of main game loop
end

puts "Goodbye!"
