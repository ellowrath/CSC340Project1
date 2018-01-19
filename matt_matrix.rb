class MattMatrix

  attr_accessor :num_rows, :num_cols

  # for testing, I should move this to driver.rb
  file_name = "data1.txt"

  def initialize(num_rows = 2, num_cols = 2)
    @num_rows = num_rows
    @num_cols = num_cols
    @matrix = Array.new(num_rows){Array.new(num_cols)}
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

  def get_rows_from_file(file_name)
    File.open(file_name) do |lines|
      rows = lines.readlines
    end
  end

  # fills all elements with zeros
  def zero_matrix
    (0..@num_rows - 1).each do |row|
      (0..@num_cols - 1).each do |column|
        @matrix[row][column] = 0
      end
    end
    @matrix
  end

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

  end
end