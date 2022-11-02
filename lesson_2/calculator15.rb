  require 'yaml'
  MESSAGES = YAML.load_file('calculator15_messages.yml')
  
  OP_TO_MESSAGE = {
    '1' => 'Adding',
    '2' => 'Subtracting',
    '3' => 'Multiplying',
    '4' => 'Dividing'
  }
  
def prompt(message)
  Kernel.puts("=> #{message}")
end

def valid_number?(num)
  num.to_i.to_s == num || num.to_f.to_s == num 
end

def operation_to_message(operator)
  return OP_TO_MESSAGE[operator]
end

prompt(MESSAGES['welcome'])

name = ''
loop do
  name = Kernel.gets().chomp()
  if name.empty?
    prompt(MESSAGES['name_prompt'])
  else
    break
  end
end

loop do
  number1 = ""
  loop do
    prompt(MESSAGES['first_num'])
    number1 = Kernel.gets().chomp()
    if valid_number?(number1)
      break
    else
      prompt(MESSAGES['valid_num'])
    end
  end
  number2 = ""
  loop do
    prompt(MESSAGES['second_num'])
    number2 = Kernel.gets().chomp()
    if valid_number?(number2)
      break
    else
      prompt(MESSAGES['valid_num'])
    end
  end
  
  prompt(MESSAGES['operator_prompt'])
  operator = ''
  loop do
    operator = Kernel.gets().chomp()
    if %w(1 2 3 4).include?(operator)
      break
    else
      prompt(MESSAGES['op_error'])
    end
  end

  prompt(MESSAGES['op_working'])

  result = case operator
           when '1'
             number1.to_i() + number2.to_i()
           when '2'
             number1.to_i() - number2.to_i()
           when '3'
             number1.to_i() * number2.to_i()
           else
             number1.to_f() / number2.to_f()
           end
  prompt("The result is #{result}")
  prompt("Do you want to perform another calculation? (Y to calculate again)")
  answer = Kernel.gets().chomp()
  break unless answer.downcase.start_with?('y')
end

prompt("Thank you for using the calculator. Goodbye!")
