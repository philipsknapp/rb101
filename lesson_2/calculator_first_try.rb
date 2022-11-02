def is_int(num)
  num.to_i.to_s == num
end

def is_float(num)
  num.to_f.to_s == num
end

def take_num(prompt)
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

num1 = take_num(">> Input your first number:")
num2 = take_num(">> Input your second number:")

operation = ""
loop do 
  puts ">> Input what operation you'd like: add, subtract, multiply, or divide:"
  operation = gets.chomp().downcase()
  case operation
    when "add"
      puts num1 + num2
      break
    when "subtract"
      puts num1 - num2
      break
    when "multiply"
      puts num1 * num2
      break
    when "divide"
      if num2 == 0
        puts "Can't divide by 0! Run me again."
      elsif (num1.class() != Float && num2.class() != Float) && num1 % num2 != 0
        puts num1.to_f / num2
      else
        puts num1/num2
      end
      break
    else
      puts "That's not an operation! Try again."
  end
end
  