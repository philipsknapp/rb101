RPS = ['r','p','s']
RPS_WORDS = {
  'r' => 'rock',
  'p' => 'paper',
  's' => 'scissors'
}

def rps_compare(rps1, rps2)
  # returns 1 if the first value wins, 2 if the second value wins
  # 0 if there's a tie
  
  case rps1
  when 'r'
    case rps2
    when 'r' then 0
    when 'p' then 2
    when 's' then 1
    end
  when 'p'
    case rps2
    when 'r' then 1
    when 'p' then 0
    when 's' then 2
    end
  when 's'
    case rps2
    when 'r' then 2
    when 'p' then 1
    when 's' then 0
    end
  end
end

def rps_compare_2(rps1, rps2)
  if rps1 == rps2
    0
  elsif RPS[RPS.index(rps1)-1] == rps2
    1
  else
    2
  end
end

player_choice = ''
loop do
  puts "==> Please enter (r)ock, (p)aper, or (s)cissors."
  player_choice = gets.downcase[0]
  break if RPS.include?(player_choice)
  puts "Invalid response!"  
end

puts "You chose #{RPS_WORDS[player_choice]}"
cpu_choice = RPS.sample
puts "Computer chose #{RPS_WORDS[cpu_choice]}"

both_choices = [player_choice, cpu_choice]
if both_choices.include?('r')
  if both_choices.include?('p')
    puts "Paper covers rock."
  elsif both_choices.include?('s')
    puts "Rock crushes scissors."
  end
elsif both_choices.include?('p')
  if both_choices.include?('s')
    puts "Scissors cut paper."
  end
end

case rps_compare_2(player_choice, cpu_choice)
when 1 then puts "You win!"
when 2 then puts "You lose!"
when 0 then puts "Tie!"
end