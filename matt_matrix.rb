=begin
Look, this thing is kind of shit
should probably redo with structs
=end

class MattMatrix

  attr_accessor :num_rows, :num_cols

  def initialize(rows = 2, cols = 2)
    @rows = rows
    @cols = cols
    zero_matrix
  end

  def rows=(rows)
    raise 'Must have at least 1 row' if rows < 1
    @rows = rows
  end

  def cols=(cols)
    raise 'Must have at least 1 column.' if cols < 1
    @cols = cols
  end

  # so, I hate the lack of *checking* done here
  def MattMatrix.[](*rows)
    @rows = rows.count


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
  # probably broken now
  def zero_matrix
    (0..@rows - 1).each do |row|
      (0..@cols - 1).each do |column|
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
    (0..@rows - 1).each do |row|
      (0..@cols - 1).each do |column|
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
    if @rows != other_matrix.rows
      false
    elsif @cols != other_matrix.cols
      false
    else
      true
    end
  end

  # need to be able to add conformable matrices
  # broke
  def +(other_matrix)
    raise 'Must be conformable matrices' unless conformable_add?(other_matrix)
    (0..@rows - 1).each do |row|
      (0..@cols - 1).each do |column|
        x = @matrix[row][column]
        y = other_matrix[row][column]
        x + y
      end
    end
  end
end