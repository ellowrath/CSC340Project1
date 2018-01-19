class MattMatrix

  attr_accessor :num_rows, :num_cols

  rows = []
  file_name = "data1.txt"

  def initialize(num_rows = 2, num_cols = 2)
    self.num_rows = num_rows
    self.num_cols = num_cols
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

  # this will destroy your matrix
  # don't call it on something important
  def make_identity

  end
end