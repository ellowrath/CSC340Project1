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
  def mult_matrices(src, dest)
    raise 'This matrix\'s columns must equal that matrix\'s rows!' unless conformable_mult? src
    dest.build(@cols_count, @cols_count)
    dest.zero_matrix
    (0..dest.rows_count - 1).each do |row|
      (0..dest.cols_count - 1).each do |column|
        (0..@rows_count - 1).each do
          (0..@cols_count - 1).each do
            dest.matrix[row][column] = dest.matrix[row][column] + (@matrix[row][column] * src.matrix[column][row])
          end
        end
      end
    end
  end
end