=begin

Look, this thing is kind of shit
should probably redo with structs

Creating a MattMatrix with no arguments gets you a 2x2 zero matrix.
A MattMatrix is not necessarily a good matrix.
A MattMatrix is more like a dangerous playground, where matrices can go
and get mixed up with other matrices.

=end

require 'csv'

# rubocop:disable ClassLength
class MattMatrix

  attr_accessor :rows_count, :cols_count, :matrix, :means, :cov_mat, :cov_det, :cov_inv

  # a little default matrix
  def initialize(rows_count = 2, cols_count = 2)
    @rows_count = rows_count
    @cols_count = cols_count
    build(@rows_count, @cols_count)
    zero_matrix
  end

  # build a matrix according to provided dimensions
  # if called on a matrix that already exists, you might
  # lose data, or retail data
  # call zero_matrix after
  def build(r, c)
    @rows_count = r
    @cols_count = c
    @matrix = Array.new(r) { Array.new(c) }
  end

  # there's all sorts of reason I might want this
  def dump_to_csv
    CSV.open('matrix.csv', 'wb') do |csv|
      (0..@rows_count - 1).each do |row|
        csv << @matrix[row]
      end
    end
  end

  # fills all elements with zeros
  # this will destroy your matrix
  # don't call it on something important
  def zero_matrix
    (0..@rows_count - 1).each do |row|
      (0..@cols_count - 1).each do |column|
        @matrix[row][column] = 0
      end
    end
    @matrix
  end

  # don't call on something important
  def make_identity
    raise 'Matrix not square.' unless @rows_count == @cols_count
    (0..@rows_count - 1).each do |row|
      (0..@cols_count - 1).each do |column|
        @matrix[row][column] = 1 if row == column
        @matrix[row][column] = 0 if row != column
      end
    end
  end

  # turns the matrix into n x 2n with the second set of columns
  # being an identity matrix
  def augment_with_identity
    @cols_count *= 2
    # lets exploit that this was once a square matrix
    (0..@rows_count - 1).each do |row|
      (@rows_count..@cols_count - 1).each do |col|
        @matrix[row][col] = 1 if row + @rows_count == col
        @matrix[row][col] = 0 if row + @rows_count != col
      end
    end
  end

  def strip_identity
    @cols_count /= 2
    (0..@rows_count - 1).each do |row|
      @matrix[row].shift(@cols_count)
    end
  end

  # need to check conformability for addition / subtraction
  def conformable_add?(o_matrix)
    raise 'Must be a MattMatrix' unless o_matrix.class == MattMatrix
    if @rows_count != o_matrix.rows_count || @cols_count != o_matrix.cols_count
      false
    else
      true
    end
  end

  def conformable_mult?(a_matrix, b_matrix)
    raise 'Must be a MattMatrix' unless a_matrix.class == MattMatrix
    raise 'Must be a MattMatrix' unless b_matrix.class == MattMatrix
    (a_matrix.cols_count == b_matrix.rows_count)
  end

  # self + src = dest
  # you can name the first matrix to store result in self ( like a += )
  def add_matrices(src, dest)
    raise 'Must be conformable matrices' unless conformable_add? src
    raise 'Must be conformable matrices' unless conformable_add? dest
    (0..@rows_count - 1).each do |row|
      (0..@cols_count - 1).each do |column|
        dest.matrix[row][column] = @matrix[row][column] + src.matrix[row][column]
      end
    end
  end

  # self - src = dest
  # you can name the first matrix to store result in self ( like a -= )
  def sub_matrices(src, dest)
    raise 'Must be conformable matrices' unless conformable_add? src
    raise 'Must be conformable matrices' unless conformable_add? dest
    (0..@rows_count - 1).each do |row|
      (0..@cols_count - 1).each do |column|
        dest.matrix[row][column] = @matrix[row][column] - src.matrix[row][column]
      end
    end
  end

  # src * dest = self
  def mult_matrices(src1, src2)
    conformable_mult? src1, src2
    build(src1.rows_count, src2.cols_count)
    zero_matrix
    (0..src1.rows_count - 1).each do |row|
      (0..src2.cols_count - 1).each do |col|
        sum = 0.0
        (0..src1.cols_count - 1).each do |ind|
          sum += src1.matrix[row][ind] * src2.matrix[ind][col]
        end
        @matrix[row][col] = sum
      end
    end
  end

  # I think you can put self into dest for a *=
  def mult_scalar_matrix(scalar, dest)
    (0..@rows_count - 1).each do |row|
      (0..@cols_count - 1).each do |column|
        dest.matrix[row][column] = scalar * @matrix[row][column]
      end
    end
  end

  # for swapping two rows' positions in the matrix
  # re-write this to do a deep copy, this .clone might cause
  # problems down the line
  def interchange_rows(row_index_a, row_index_b)
    temp = @matrix[row_index_a].clone
    @matrix[row_index_a] = @matrix[row_index_b].clone
    @matrix[row_index_b] = temp.clone
  end

  # The way I handled this is a little confusing.
  def mult_row_by_cons(row, cons)
    (0..@cols_count - 1).each { |col| @matrix[row][col] = @matrix[row][col] * cons } if row.class == Integer
    (0..row.length - 1).each { |col| row[col] = row[col] * cons } if row.class == Array
  end

  def calc_pivot index
    row = index
    col = index
    # -1 because I'm returning an index, and index 0 very possibly could
    # be the pivot index
    p_index = -1
    p_value = 0.0 # might have to make this much smaller
    (row..@rows_count - 1).each do |r_index|
      if @matrix[r_index][col].abs > p_value
        p_value = @matrix[r_index][col]
        p_index = r_index
      end
    end
    p_index
  end

  # for a nicer representation for testing
  # prints the current matrix
  def print_matrix
    (0..@rows_count - 1).each { |row| p @matrix[row]}
    puts ""
  end

  # here's the bad boy
  def gauss_jordan_elim
    (0..@rows_count - 1).each do |row|
      pivot = calc_pivot row
      raise 'No unique solution exists' if pivot == -1
      interchange_rows(row, pivot)
      mult_row_by_cons(row, 1/@matrix[row][row])
      # (row..@rows_count - 1).each do |i_row|
      (0..@rows_count - 1).each do |i_row|
        next if row == i_row
        temp_vec = @matrix[row].map { |e| e.dup }
        temp_cons = @matrix[i_row][row]
        mult_row_by_cons(temp_vec, temp_cons)
        (0..@cols_count - 1).each { |c| @matrix[i_row][c] = @matrix[i_row][c] - temp_vec[c] }
      end
    end
  end

  def gaussian_elim
    ans = []
    (0..@rows_count - 1).each do |row|
      pivot = calc_pivot row
      raise 'No unique solution exists' if pivot == -1
      interchange_rows(row, pivot)
      # this whole loop is a travesty
      (row..@rows_count - 1).each do |i_row|
        next if row == i_row
        temp_cons = @matrix[i_row][row] / @matrix[row][row]
        temp_vec = @matrix[row].map { |e| e.dup }
        mult_row_by_cons(temp_vec, temp_cons)
        (row..@cols_count - 1).each do |c|
          @matrix[i_row][c] = @matrix[i_row][c] - temp_vec[c]
        end
      end
    end
    # matrix should now be in echelon form
    (@rows_count - 1).downto(0) do |row|
      sum = 0
      (row + 1..@cols_count - 2).each { |col| sum += @matrix[row][col] * ans[col] }
      ans[row] = (1/@matrix[row][row]) * (@matrix[row][@cols_count - 1] - sum)
    end
    p ans
    puts ""
  end

  def inverse
    augment_with_identity
    (0..@rows_count - 1).each do |row|
      pivot = calc_pivot row
      raise 'No unique solution exists' if pivot == -1
      interchange_rows(row, pivot)
      mult_row_by_cons(row, 1/@matrix[row][row])
      (0..@rows_count - 1).each do |i_row|
        next if row == i_row
        temp_vec = @matrix[row].map { |e| e.dup }
        temp_cons = @matrix[i_row][row]
        mult_row_by_cons(temp_vec, temp_cons)
        (0..@cols_count - 1).each { |c| @matrix[i_row][c] = @matrix[i_row][c] - temp_vec[c] }
      end
    end
    strip_identity
  end

  def determinant
    r = 0
    (0..@rows_count - 1).each do |row|
      pivot = calc_pivot row
      raise 'No unique solution exists' if pivot == -1
      if @matrix[pivot][row] > @matrix[row][row]
        interchange_rows(row, pivot)
        r += 1
      end
      (row..@rows_count - 1).each do |i_row|
        next if row == i_row
        temp_cons = @matrix[i_row][row] / @matrix[row][row]
        temp_vec = @matrix[row].map { |e| e.dup }
        mult_row_by_cons(temp_vec, temp_cons)
        (row..@cols_count - 1).each do |c|
          @matrix[i_row][c] = @matrix[i_row][c] - temp_vec[c]
        end
      end
    end
    delta = 1
    (0..@rows_count - 1).each do |row|
      delta *= @matrix[row][row]
    end
    # puts delta
    # puts r
    delta *= -1**r
    # puts delta
  end

  def calc_cov_det
    @cov_det = @cov_mat.determinant
  end

  def calc_cov_inv
    @cov_inv = Marshal.load(Marshal.dump(@cov_mat))
    @cov_inv.inverse
  end

  # this is shit, look up a better way
  def transpose
    new_rows_count = @cols_count
    new_cols_count = @rows_count
    # 1d array, column major order
    temp_vector = @matrix.flatten
    @rows_count = new_rows_count
    @cols_count = new_cols_count
    build(@rows_count, @cols_count)
    (0..@rows_count - 1).each do |row|
      @matrix[row] = temp_vector.slice!(0..@cols_count - 1)
    end
  end

  # this is a hairy beast
  def calc_covariance
    # in case we haven't calculated our means yet
    calc_mean_vectors if @means.class == NilClass
    temp_class = Marshal.load(Marshal.dump(@matrix))
    (0..temp_class.length - 1).each do |row|
      (0..temp_class[0].length - 1).each do |col|
        temp_class[row][col] -= @means[col]
      end
    end
    sum = MattMatrix.new
    sum.build(temp_class[0].length, temp_class[0].length)
    sum.zero_matrix
    temp_vec_a = MattMatrix.new
    temp_vec_b = MattMatrix.new
    temp_vec_c = MattMatrix.new
    temp_vec_a.build(1, temp_class[0].length)
    temp_vec_b.build(1, temp_class[0].length)
    temp_vec_c.build(temp_class.length, temp_class.length)
    (0..temp_class.length - 1).each do |vec|
      (0..temp_class[0].length - 1).each do |cell|
        temp_vec_a.matrix[0][cell] = temp_class[vec][cell]
      end
      temp_vec_b = temp_vec_a.clone
      temp_vec_a.transpose
      temp_vec_c.mult_matrices(temp_vec_a, temp_vec_b)
      # need to reset this one, or it'll 'rotate'
      temp_vec_a.build(1, temp_class[0].length)
      (0..temp_vec_c.rows_count - 1).each do |row|
        (0..temp_vec_c.cols_count - 1).each do |col|
          sum.matrix[row][col] += temp_vec_c.matrix[row][col]
        end
      end
    end
    @cov_mat = MattMatrix.new
    @cov_mat.build(sum.rows_count, sum.cols_count)
    @cov_mat.zero_matrix
    scalar = (1/temp_class.length.to_f)
    sum.mult_scalar_matrix(scalar, cov_mat)
  end

  def calc_mean_vectors
    @means = Array.new(@cols_count, 0)
    (0..@rows_count - 1).each do |row|
      (0..@cols_count - 1).each do |col|
        @means[col] += @matrix[row][col]
      end
    end
    (0..@means.length - 1).each { |i| @means[i] /= @rows_count }
  end
end
# rubocop:enable ClassLength