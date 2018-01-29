=begin

Look, this thing is kind of shit
should probably redo with structs

Creating a MattMatrix with no arguments gets you a 2x2 zero matrix.

=end

require 'csv'

# rubocop:disable ClassLength
class MattMatrix

  attr_accessor :rows_count, :cols_count, :matrix, :file_name

  def initialize(rows_count = 2, cols_count = 2, file_name = 'no_file_name')
    @rows_count = rows_count
    @cols_count = cols_count
    @file_name = file_name
    if file_name == 'no_file_name'
      build(@rows_count, @cols_count)
      zero_matrix
    else
      build_from_file(file_name)
    end
  end

  # build a matrix according to provided dimensions
  def build(r, c)
    @rows_count = r
    @cols_count = c
    @matrix = Array.new(r) { Array.new(c) }
  end

  # builds a matrix from a file of tab separated floats
  def build_from_file(file_name)
    temp = File.open(file_name).readlines
    @rows_count = temp.length
    temp.each_index do |line|
      temp[line] = temp[line].delete("\n").split("\t")
      temp[line].each_index { |i| temp[line][i] = temp[line][i].to_f }
    end
    @cols_count = temp[0].length
    build(@rows_count, @cols_count)
    (0..rows_count - 1).each { |row| @matrix[row] = temp[row] }
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

  # need to check conformability for addition / subtraction
  def conformable_add?(o_matrix)
    raise 'Must be a MattMatrix' unless o_matrix.class == MattMatrix
    if @rows_count != o_matrix.rows_count || @cols_count != o_matrix.cols_count
      false
    else
      true
    end
  end

  def conformable_mult?(o_matrix)
    raise 'Must be a MattMatrix' unless o_matrix.class == MattMatrix
    (@cols_count == o_matrix.rows_count)
    # if @cols_count != o_matrix.rows_count
    #   false
    # else
    #   true
    # end
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

  # self * src = dest
  # you cannot *= this one
  # something's not working here
  def mult_matrices(src, dest)
    raise 'Matrices not conformable for multiplication.' unless conformable_mult? src
    dest.build(@cols_count, @cols_count)
    dest.zero_matrix
    (0..dest.rows_count - 1).each do |row|
      (0..dest.cols_count - 1).each do |column|
        (0..@cols_count - 1).each do |index|
          dest.matrix[row][column] = dest.matrix[row][column] + (@matrix[row][index] * src.matrix[index][column])
        end
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
    puts delta
    puts r
    delta *= -1**r
    puts delta
  end
end
# rubocop:enable ClassLength
