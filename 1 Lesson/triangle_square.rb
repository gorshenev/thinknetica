puts 'Введите основание треугольника'
a = gets.chomp.to_f
puts 'Введите высоту треугольника'
h = gets.chomp.to_f

s = 0.5 * a * h

puts "Площадь треугольника = #{(s % 1 == 0) ? s.to_i : s}"