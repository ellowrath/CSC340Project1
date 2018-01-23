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

    my_matrix = MattMatrix.new(4, 5)
    rand_fill(my_matrix)
    my_matrix.print_matrix

    my_matrix.gauss_jordan_elim
    my_matrix.print_matrix

#     my_matrix.interchange_rows(2, 4 )
#     p my_matrix

#    my_matrix.mult_row_by_cons(1, 2.5)
#    p my_matrix

#    my_second_matrix = MattMatrix.new(3, 2)
#    rand_fill(my_second_matrix)
#    p my_second_matrix

#    my_third_matrix = MattMatrix.new
#    my_matrix.mult_matrices(my_second_matrix, my_third_matrix)
#    p my_third_matrix

#    my_fourth_matrix = MattMatrix.new(2, 3)
#    my_matrix.mult_scalar_matrix(2, my_fourth_matrix)
#    p my_fourth_matrix


#    my_data_matrix = MattMatrix.new(2, 2,'data1.txt')
#    p my_data_matrix

#    my_identity_matrix = MattMatrix.new(10, 10)
#    my_identity_matrix.make_identity
#    p my_identity_matrix
  end
end

my_driver = Driver.new
my_driver.go
