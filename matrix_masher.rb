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

  # this strips the leading identity matrix if you successfully
  # calculated an inverse.
  def strip_identity(a)
    new_c = a[0].length / 2
    (0...a.length).each { |r| a[r].shift(new_c) }
  end

  def conformable_add?(a, b)
    a.length == b.length && a[0].length == b[0].length
  end

  def conformable_mult?(a, b)
    a[0].length == b.length
  end

  def add_matrices(a, b)
    raise 'Matrices are not conformable for addition/subtraction.' unless conformable_add?(a, b)
    apb = Array.new(a.length) { Array.new(a[0].length) }
    (0...a.length).each do |r|
      (0...a[0].length).each do |c|
        apb[r][c] = a[r][c] + b[r][c]
      end
    end
    apb
  end

  def sub_matrices(a, b)
    raise 'Matrices are not conformable for addition/subtraction.' unless conformable_add?(a, b)
    amb = Array.new(a.length) { Array.new(a[0].length) }
    (0...a.length).each do |r|
      (0...a[0].length).each do |c|
        amb[r][c] = a[r][c] - b[r][c]
      end
    end
    amb
  end

  def mult_matrices(a, b)
    raise 'Matrices are not conformable for multiplication.' unless conformable_mult?(a, b)
    atb = Array.new(a.length) { Array.new(b[0].length) }
    zero_matrix(atb)
    (0...a.length).each do |r|
      (0...b[0].length).each do |c|
        (0...a[0].length).each do |i|
          atb[r][c] += a[r][i] * b[i][c]
        end
      end
    end
    atb
  end

  def mult_matrix_scalar(m, s)
    atb = Array.new(m.length) { Array.new(m[0].length) }
    zero_matrix(atb)
    (0...a.length).each do |r|
      (0...a[0].length).each do |c|
        atb[r][c] = a[r][c] * s
      end
    end
    atb
  end

  def mult_row_constant(m, r, s)
    (0...m[r].length).each do |c|
      m[r][c] *= s
    end
  end

  def mult_vec_constant(r, s)
    (0...r.length).each do |c|
      r[c] *= s
    end
  end

  def interchange_rows(m, r1, r2)
    puts 'interchange_rows() called.'
    t = Marshal.load(Marshal.dump(m[r1]))
    m[r1] = Marshal.load(Marshal.dump(m[r2]))
    m[r2] = Marshal.load(Marshal.dump(t))
  end

  def calc_pivot(m, i)
    r = i
    c = i
    pi = -1
    pv = 0.0
    (r...m.length).each do |ri|
      if m[ri][c].abs > pv
        pv = m[ri][c]
        pi = ri
      end
    end
    pi
  end

  def gauss_jordan_elim(m)
    gje = Array.new(m.length) { Array.new(m[0].length) }
    zero_matrix(gje)
    (0...m.length).each do |r|
      p = calc_pivot(m, r)
      raise 'No unique solution exists.' if p == -1
      interchange_rows(m, r, p) if p > r
      mult_row_constant(m, r, 1 / m[r][r])
      (0...m.length).each do |i|
        next if r == i
        tv = m[r].clone
        tc = m[i][r]
        mult_vec_constant(tv, tc)
        (0...m[i].length).each { |c| gje[i][c] -= tv[c] }
      end
    end
    gje
  end
end