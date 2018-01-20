=begin

Look, this thing is kind of shit
should probably redo with structs

Creating a MattMatrix with no arguments gets you a 2x2 zero matrix.

=end

class MattMatrix
  attr_accessor :rows_count, :cols_count, :matrix

  def initialize(*args)
    # we got no arguments, just an empty matrix
    if args.length.zero?
      @rows_count = 2
      @cols_count = 2
      build(@rows_count, @cols_count)
      zero_matrix
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

  # this function won't work yet
  def get_data_from_file(file_name)
    File.open(file_name) do |lines|
      rows = lines.readlines
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

  # turns the matrix into an identity matrix
  # this will destroy your matrix
  # don't call it on something important
  # probably broken now
  def make_identity
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
  # might be able to overload '=='
  # ya, broke
  def conformable_add?(other_matrix)
    raise 'Must be a MattMatrix' unless other_matrix.class == MattMatrix
    if @rows_count != other_matrix.rows_count || @cols_count != other_matrix.cols_count
      false
    else
      true
    end
  end

  # self + src = dest
  def add_matrices(src, dest)
    raise 'Must be conformable matrices' unless conformable_add? src
    (0..@rows_count - 1).each do |row|
      (0..@cols_count - 1).each do |column|
        dest.matrix[row][column] = @matrix[row][column] + src.matrix[row][column]
      end
    end
  end
end