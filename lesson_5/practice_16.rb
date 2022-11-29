HEX_CHARS = %w(0 1 2 3 4 5 6 7 8 9 a b c d e f)

def hex_string(length)
  result = ''
  length.times { result << HEX_CHARS.sample }
  result
end

hex_arr = []
hex_arr << hex_string(8)
hex_arr << hex_string(4)
hex_arr << hex_string(4)
hex_arr << hex_string(4)
hex_arr << hex_string(12)

p hex_arr.join('-')
