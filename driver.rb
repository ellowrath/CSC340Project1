require_relative 'matt_matrix'
class Driver

  file_name = 'data1.txt'
  srand Time.now.to_i

  def rand_fill(m)
    (0..m.rows_count - 1).step do |row|
      (0..m.cols_count - 1).step do |column|
        m.matrix[row][column] = rand(0.0..10.0)
      end
    end
  end

  def go
    my_matrix = MattMatrix.new
    rand_fill(my_matrix)
    p my_matrix

    my_second_matrix = MattMatrix.new
    rand_fill(my_second_matrix)
    p my_second_matrix

    my_third_matrix = MattMatrix.new
    my_matrix.sub_matrices(my_second_matrix, my_third_matrix)

    p my_third_matrix

  end
end

my_driver = Driver.new
my_driver.go
