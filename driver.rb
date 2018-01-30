require_relative 'matt_matrix'
class Driver

  srand Time.now.to_i

  def rand_fill(m)
    (0..m.rows_count - 1).step do |row|
      (0..m.cols_count - 1).step do |column|
        m.matrix[row][column] = rand(0.0..10.0)
      end
    end
  end

  def test_build_func(r, c)
    puts 'Building a matrix with ' + r.to_s + ' rows and ' + c.to_s + ' columns.'
    m = MattMatrix.new
    puts 'A matrix created without arguments:'
    m.print_matrix
    puts 'Calling build(' + r.to_s + ', ' + c.to_s + ')'
    puts ''
    m.build(r, c)
    puts 'The matrix, post function call:'
    m.print_matrix
    if m.rows_count == r && m.cols_count == c then puts 'Test Succeeded' else puts 'Test Failed' end
  end

  def test_zeromatrix_func
    puts 'Fills all of a matrix\'s cells with zeros.'
    puts 'It is called when a matrix is created, but we\'ll test it here too.'
    m = MattMatrix.new
    puts 'A matrix created without arguments:'
    m.print_matrix
    puts 'Calling build(5, 5)'
    puts ''
    m.build(5, 5)
    puts 'The matrix, post build() function call:'
    m.print_matrix
    puts 'Calling zeromatrix()'
    puts ''
    m.zero_matrix
    puts 'The matrix post zeromatrix() function call:'
    m.print_matrix
    result = 'Test Succeeded'
    (0..m.rows_count - 1).each do |row|
      (0..m.cols_count - 1).each do |col|
        result = 'Test Failed' if m.matrix[row][col] != 0
      end
    end
    puts result
  end

  def test_make_identity_func
    puts 'Fills all of a matrix\'s cells with zeros, except the diagonal'
    puts 'which should be filled with ones.'
    m = MattMatrix.new
    puts 'A matrix created without arguments:'
    m.print_matrix
    puts 'Calling build(5, 5)'
    puts ''
    m.build(5, 5)
    puts 'The matrix, post build() function call:'
    m.print_matrix
    puts 'Calling make_identity()'
    puts ''
    m.make_identity
    puts 'The matrix, post make_identity() function call:'
    m.print_matrix
    puts 'Write a verification later schmuck.'
  end

  # this is not a good test
  def test_transpose
    m = MattMatrix.new
    m.build(110, 1)
    rand_fill(m)
    m.print_matrix
    m.transpose
    m.print_matrix
  end

  def test_matrix_multiplication
    m = MattMatrix.new
    n = MattMatrix.new
    o = MattMatrix.new
    m.build(2, 3)
    n.build(3, 2)
    rand_fill(m)
    rand_fill(n)
    m.print_matrix
    n.print_matrix
    o.mult_matrices(m, n)
    o.print_matrix

  end
end

my_driver = Driver.new
my_driver.test_matrix_multiplication