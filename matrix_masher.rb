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
    (0...m.length).each do |r|
      (0...m[0].length).each do |c|
        atb[r][c] = m[r][c] * s
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

  def transpose(a)
    nr = a[0].length
    nc = a.length
    t = a.flatten
    b = create_matrix(nr, nc)
    (0...nc).each { |c| (0...nr).each { |r| b[r][c] = t.shift } }
    b
  end

  def gauss_jordan_elim(m)
    gje = Marshal.load(Marshal.dump(m))
    (0...gje.length).each do |r|
      p = calc_pivot(gje, r)
      raise 'No unique solution exists.' if p == -1
      interchange_rows(gje, r, p) if p > r
      mult_row_constant(gje, r, 1 / gje[r][r])
      (0...gje.length).each do |i|
        next if r == i
        tv = gje[r].clone
        tc = gje[i][r]
        mult_vec_constant(tv, tc)
        (0...gje[i].length).each { |c| gje[i][c] -= tv[c] }
      end
    end
    gje
  end

  def gaussian_elim(m)
    ge = []
    t = Marshal.load(Marshal.dump(m))
    (0...t.length).each do |r|
      p = calc_pivot(t, r)
      raise 'No unique solution exists.' if p == -1
      interchange_rows(t, r, p) if p > r
      (r...t.length).each do |i|
        next if r == i
        tc = t[i][r] / t[r][r]
        v = Marshal.load(Marshal.dump(t))
        mult_row_constant(v, r, tc)
        (r...t[0].length).each do |c|
          t[i][c] = t[i][c] - v[r][c]
        end
      end
    end
    (t.length - 1).downto(0) do |r|
      sum = 0
      (r + 1..t[0].length - 2).each { |c| sum += (t[r][c] * ge[c]) }
      ge[r] = (1 / t[r][r]) * (t[r][t[0].length - 1] - sum)
    end
    ge
  end

  def trace(m)
    sum = 0
    (0...m.length).each do |r|
      (0...m[0].length).each do |c|
        sum += m[r][c] if r == c
      end
    end
    sum
  end

  def calc_mat_norm(m)
    max_sum = 0
    (0...m.length).each do |r|
      sum = 0
      (0...m[0].length).each do |c|
        sum += m[r][c].abs
      end
      max_sum = sum if sum > max_sum
    end
    max_sum
  end
end