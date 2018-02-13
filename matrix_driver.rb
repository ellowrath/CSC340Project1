load('matrix_masher.rb')

class MatrixDriver
  include(MMasher)
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

  def scrap
    m = create_matrix(1, 3)
    puts get_num_rows(m)
  end
end

driver = MatrixDriver.new
driver.test_conformable_mult