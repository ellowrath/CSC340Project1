load('matrix_masher.rb')

class MatrixDriver
  include(MMasher)
  def rand_fill(a)
    srand
    (0...a.length).step do |r|
      (0...a[0].length).step do |c|
        a[r][c] = rand(0.0..10.0)
      end
    end
  end

  def test_create_matrix
    m = create_matrix(2, 3)
    puts m.class
    p m
  end

  def test_get_num_rows
    m = create_matrix(2, 2)
    puts get_num_rows(m)
  end

  def test_get_num_cols
    m = create_matrix(2, 3)
    puts get_num_cols(m)
  end

  def test_square
    m = create_matrix(2, 2)
    n = create_matrix(2, 3)
    puts square? m
    puts square? n
  end

  def test_zero_matrix
    m = create_matrix(3, 3)
    zero_matrix(m)
    p m
  end

  def test_make_identity
    m = create_matrix(4, 4)
    make_identity(m)
    p m
  end

  def test_print_matrix
    m = create_matrix(4, 4)
    make_identity(m)
    print_matrix(m)
  end

  def test_augment_with_identity
    m = create_matrix(5, 5)
    zero_matrix(m)
    print_matrix(m)
    puts ''
    augment_with_identity(m)
    print_matrix(m)
  end

  def test_strip_identity
    m = create_matrix(6, 6)
    zero_matrix(m)
    print_matrix(m)
    puts ''
    augment_with_identity(m)
    print_matrix(m)
    puts ''
    strip_identity(m)
    print_matrix(m)
  end

  def test_conformable_add
    m = create_matrix(5, 5,)
    n = create_matrix(5, 5)
    puts conformable_add?(m, n)
    o = create_matrix(2, 3)
    p = create_matrix(6, 5)
    puts conformable_add?(o, p)
  end

  def test_conformable_mult
    m = create_matrix(3, 5)
    n = create_matrix(5, 6)
    puts conformable_mult?(m, n)
    o = create_matrix(2, 3)
    p = create_matrix(6, 5)
    puts conformable_mult?(o, p)
  end

  def test_add_matrices
    m = create_matrix(4, 4)
    n = create_matrix(4, 4)
    rand_fill(m)
    rand_fill(n)
    print_matrix(m)
    puts ''
    print_matrix(n)
    puts ''
    o = add_matrices(m, n)
    print_matrix(o)
  end

  def test_sub_matrices
    m = create_matrix(4, 4)
    n = create_matrix(4, 4)
    rand_fill(m)
    rand_fill(n)
    print_matrix(m)
    puts ''
    print_matrix(n)
    puts ''
    o = sub_matrices(m, n)
    print_matrix(o)
  end

  def test_mult_matrices
    m = create_matrix(2, 2)
    n = create_matrix(2,2)
    rand_fill(m)
    rand_fill(n)
    print_matrix(m)
    puts ''
    print_matrix(n)
    puts ''
    o = mult_matrices(m, n)
    print_matrix(o)
  end

  def test_mult_matrix_scalar
    m = create_matrix(3, 3)
    n = 4
    rand_fill(m)
    print_matrix(m)
    puts ''
    o = mult_matrix_scalar(m, n)
    print_matrix(o)
  end

  def test_interchange_rows
    m = create_matrix(4, 4)
    rand_fill(m)
    print_matrix(m)
    puts ''
    interchange_rows(m, 1, 3)
    print_matrix(m)
  end

  def test_mult_row_cons
    m = create_matrix(3, 3)
    rand_fill(m)
    print_matrix(m)
    puts ''
    mult_row_constant(m, 1, 2)
    print_matrix(m)
  end

  def test_gje
    m = create_matrix(3, 4)
    m[0] = [4.0, -2.0, 1.0, 11.0]
    m[1] = [8.0, 5.0, -4.0, 14.0]
    m[2] = [-3.0, 1.0, 5.0, 10.0]
    print_matrix(m)
    puts ''
    n = gauss_jordan_elim(m)
    print(n)
  end

  def scrap
    m = create_matrix(1, 3)
    puts get_num_rows(m)
  end
end

driver = MatrixDriver.new
driver.test_gje