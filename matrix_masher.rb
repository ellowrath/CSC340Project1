module MMasher
  def create_matrix(r, c)
    Array.new(r) { Array.new(c) }
  end

  def get_num_rows(a)
    raise 'Object is not an Array.' unless a.class == Array
    a.length
  end

  def get_num_cols(a)
    raise 'Object is not at least a 2d Matrix.' unless a[0].class == Array
    a[0].length
  end

  def square?(a)
    raise 'Object is not an Array.' unless a.class == Array
    raise 'Object is not a 2d Matrix.' unless a[0].class == Array
    a.length == a[0].length
  end

  def zero_matrix(a)
    (0...a.length).each do |r|
      (0...a[0].length).each do |c|
        a[r][c] = 0
      end
    end
  end

  def make_identity(a)
    raise 'Matrix is not square.' unless square?(a)
    (0...a.length).each do |r|
      (0...a[0].length).each do |c|
        a[r][c] = 1 if r == c
        a[r][c] = 0 if r != c
      end
    end
  end

  def print_matrix(a)
    (0...a.length).each { |r| p a[r] }
  end

  def augment_with_identity(a)
    new_c_count = a[0].length * 2
    (0...a.length).each do |r|
      (a.length...new_c_count).each do |c|
        a[r][c] = 1 if r + a.length == c
        a[r][c] = 0 if r + a.length != c
      end
    end
  end
end