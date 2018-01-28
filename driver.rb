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

    my_matrix = MattMatrix.new(4, 3)
    my_matrix_2 = MattMatrix.new(3, 4)
    my_matrix_3 = MattMatrix.new
    rand_fill(my_matrix)
    rand_fill(my_matrix_2)
    my_matrix.print_matrix
    my_matrix.mult_matrices(my_matrix_2, my_matrix_3)
    my_matrix_3.print_matrix
    # my_matrix.print_matrix
    # my_matrix.dump_to_csv
    # my_matrix.determinant
    # my_matrix.inverse
    # my_matrix.print_matrix
    # only way I know how to deep copy an object with arrays
    # my_matrix_2 = Marshal.load( Marshal.dump(my_matrix))
    # my_matrix.print_matrix
    # my_matrix_2.print_matrix

    # my_matrix.make_identity
    # my_matrix.gauss_jordan_elim
    # my_matrix.print_matrix

    # my_matrix_2.gaussian_elim
    # my_matrix_2.print_matrix

  end
end

my_driver = Driver.new
my_driver.go
