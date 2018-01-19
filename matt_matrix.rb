class MattMatrix

  attr_accessor :num_rows, :num_cols, :matrix

  def initialize(num_rows = 2, num_cols = 2)
    @num_rows = num_rows
    @num_cols = num_cols
    @matrix = Array.new(num_rows) { Array.new(num_cols) }
    zero_matrix
  end

  def num_rows=(num_rows)
    raise 'Must have at least 1 row' if num_rows < 1
    @num_rows = num_rows
  end

  def num_cols=(num_cols)
    raise 'Must have at least 1 column.' if num_cols < 1
    @num_cols = num_cols
  end

  def get_data_from_file(file_name)
    File.open(file_name) do |lines|
      rows = lines.readlines
    end
  end

  # fills all elements with zeros
  # this will destroy your matrix
  # don't call it on something important
  def zero_matrix
    (0..@num_rows - 1).each do |row|
      (0..@num_cols - 1).each do |column|
        @matrix[row][column] = 0
      end
    end
    @matrix
  end

  # turns the matrix into an identity matrix
  # this will destroy your matrix
  # don't call it on something important
  def make_identity
    (0..@num_rows - 1).each do |row|
      (0..@num_cols - 1).each do |column|
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
  def conformable_add?(other_matrix)
    raise 'Must be a MattMatrix' unless other_matrix.class == MattMatrix
    if @num_rows != other_matrix.num_rows
      false
    elsif @num_cols != other_matrix.num_cols
      false
    else
      true
    end
  end

  # need to be able to add conformable matrices
  def +(other_matrix)
    raise 'Must be conformable matrices' unless conformable_add?(other_matrix)
    (0..@num_rows - 1).each do |row|
      (0..@num_cols - 1).each do |column|
        x = @matrix[row][column]
        y = other_matrix[row][column]
        x + y
      end
    end
  end
end