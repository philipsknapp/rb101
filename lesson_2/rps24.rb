VALID_CHOICES = %w(rock lizard spock scissors paper)
CHOICE_ABBREV = {
  'r' => 'rock',
  'l' => 'lizard',
  's' => 'spock',
  'c' => 'scissors',
  'p' => 'paper'
}

def prompt(message)
  puts "=> #{message}"
end

def win?(first, second)
  first_position = VALID_CHOICES.index(first)
  second_position = VALID_CHOICES.index(second)
  (first_position + 1) % 5 == second_position ||
    (first_position + 3) % 5 == second_position
end

def display_results(choice, computer_choice)
  if win?(choice, computer_choice)
    prompt("You won!")
  elsif win?(computer_choice, choice)
    prompt("You lost!")
  else
    prompt("Tie!")
  end
end

player_wins = 0
computer_wins = 0

loop do
  choice = ''
  loop do
    prompt("Choose one: (r)ock, (p)aper, s(c)issors, (l)izard, (s)pock")
    choice = gets.chomp.downcase
    if VALID_CHOICES.include?(choice)
      break
    elsif VALID_CHOICES.include?(CHOICE_ABBREV[choice])
      choice = CHOICE_ABBREV[choice]
      break
    else
      prompt("That's not a valid choice.")
    end
  end

  computer_choice = VALID_CHOICES.sample
  puts "You chose #{choice}; Computer chose: #{computer_choice}"
  display_results(choice, computer_choice)

  if win?(choice, computer_choice)
    player_wins += 1
  elsif win?(computer_choice, choice)
    computer_wins += 1
  end

  prompt("You have won #{player_wins} games. \n
    The computer has won #{computer_wins} games.")

  if player_wins >= 3
    puts "You are the grand winner!"
    break
  elsif computer_wins >= 3
    puts "The computer is the grand winner!"
    break
  else
    prompt("Do you want to play again?")
    answer = gets.chomp
    break unless answer.downcase().start_with?('y')
  end
end

prompt('Thank you for playing. Goodbye!')
