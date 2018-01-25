=begin

Look, this thing is kind of shit
should probably redo with structs

Creating a MattMatrix with no arguments gets you a 2x2 zero matrix.

=end

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

  def rows_count=(rows_count)
    raise 'Must have at least 1 row' if rows_count < 1
    @rows_count = rows_count
  end

  def cols_count=(cols_count)
    raise 'Must have at least 1 column.' if cols_count < 1
    @cols_count = cols_count
  end

  def matrix=(matrix)
    @matrix = matrix
  end

  def build(r, c)
    @matrix = Array.new(r) { Array.new(c) }
  end

  # builds a matrix from a file of tab separated floats
  def build_from_file(file_name)
    temp = File.open(file_name).readlines
    @rows_count = temp.length
    temp.each_index do |line|
      temp[line] = temp[line].delete("\n").split("\t")
      temp[line].each_index {|i| temp[line][i] = temp[line][i].to_f}
    end
    @cols_count = temp[0].length
    build(@rows_count, @cols_count)
    (0..rows_count - 1).each { |row| @matrix[row] = temp[row] }
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

  # turns the matrix into an identity matrix
  # this will destroy your matrix
  # don't call it on something important
  # probably broken now
  def make_identity
    raise 'It has to be a square matrix to be an identity matrix' unless @rows_count == @cols_count
    (0..@rows_count - 1).each do |row|
      (0..@cols_count - 1).each do |column|
        if row == column
          @matrix[row][column] = 1
        else
          @matrix[row][column] = 0
        end
      end
    end
    @matrix
  end

  # need to check conformability for addition / subtraction
  def conformable_add?(other_matrix)
    raise 'Must be a MattMatrix' unless other_matrix.class == MattMatrix
    if @rows_count != other_matrix.rows_count || @cols_count != other_matrix.cols_count
      false
    else
      true
    end
  end

  def conformable_mult?(other_matrix)
    raise 'Must be a MattMatrix' unless other_matrix.class == MattMatrix
    if @cols_count != other_matrix.rows_count
      false
    else
      true
    end
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
  def mult_matrices(src, dest)
    raise 'This matrix\'s columns must equal that matrix\'s rows!' unless conformable_mult? src
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
      multiplier = 1/@matrix[row][row]
      mult_row_by_cons(row, multiplier)
      # (row..@rows_count - 1).each do |i_row|
      (0..@rows_count - 1).each do |i_row|
        next if row == i_row
        temp_vec = @matrix[row].clone
        temp_cons = @matrix[i_row][row]
        mult_row_by_cons(temp_vec, temp_cons)
        (0..@cols_count - 1).each { |c| @matrix[i_row][c] = @matrix[i_row][c] - temp_vec[c] }
      end
    end
  end

  def gaussian_elim
    (0..@rows_count - 1).each do |row|
      pivot = calc_pivot row
      raise 'No unique solution exists' if pivot == -1
      interchange_rows(row, pivot)
      (row..@rows_count - 1).each do |i_row|
        next if row == i_row
        multiplier = @matrix[i_row][row] / @matrix[row][row]
        temp_vec = @matrix[row].clone
        mult_row_by_cons(temp_vec, multiplier)
        (i_row..@rows_count).each { |c| @matrix[i_row][c] = @matrix[i_row][c] - temp_vec[c] }
      end
    end
  end
end