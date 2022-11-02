def is_int(num)
  num.to_i.to_s == num
end

def is_float(num)
  num.to_f.to_s == num
end

def get_num(prompt)
  num = ""
  loop do
    puts(prompt)
    num = gets.chomp()
    if is_int(num)
      return num.to_i
    elsif is_float(num)
      return num.to_f
    else
      puts ">> Must be a float or integer! Try again."
    end
  end
end

puts <<-WEL
  "Welcome to the loan calculator! 
  I'll need to know a few things before we can figure out your loan information."
  WEL
balance = get_num("Please enter your loan balance")
apr = get_num("Please enter your APR")
puts "Do you mean that your APR is %#{apr}? (Y/N)"
case gets.chomp().downcase
when 'y'
  puts "Thanks!"
  apr = apr.to_f / 100
when 'n'
  puts "Ok."
else
  if apr >= 1.0
    puts "I'm assuming the answer is yes."
    apr = apr.to_f / 100
  else
    puts "I'm assuming the answer is no."
  end
end

duration = get_num("Please enter your loan duration")
puts "Is that #{duration} months or #{duration} years? (respond with M/Y)"
duration *= 12 if gets.chomp().downcase.start_with?('y')
puts "Thanks!"

puts "I've got what I need to calculate, thanks!"

monthly_rate = apr / 12 # still expressed as a decimal val
monthly_payment = balance *
                  (monthly_rate /
                  (1 - ((1 + monthly_rate)**(-duration))))

puts "Got it!"
puts "Your monthly interest rate is %#{(monthly_rate * 100).round(2)}"
puts "Your loan duration is #{duration} months"
puts "Your monthly payment is $#{monthly_payment.round(2)}"

puts "Thank you for using this calculator!"
