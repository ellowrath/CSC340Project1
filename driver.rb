require_relative 'matt_matrix'
class Driver

  file_name = 'data1.txt'
  srand Time.now.to_i

  def go
    my_matrix = MattMatrix.new(2, 2)
    my_second_matrix = MattMatrix.new(3, 3)

    (0..1).each do |row|
      (0..1).each do |column|
        my_matrix.matrix[row][column] = rand(10)
      end
    end

    (0..2).each do |r|
      (0..2).each do |c|
        my_second_matrix.matrix[r][c] = rand(10)
      end
    end

    p my_matrix
    p my_second_matrix

    puts my_matrix.conformable_add?(my_second_matrix)
    # my_third_matrix = MattMatrix.new(2, 2)
    # my_third_matrix.matrix = my_matrix.matrix + my_second_matrix.matrix

    # p my_third_matrix

  end
end

my_driver = Driver.new
my_driver.go
