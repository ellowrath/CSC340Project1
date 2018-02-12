module MMasher
  def create_matrix(r, c)
    Array.new(r) { Array.new(c) }
  end

  def get_num_rows(a)
    raise 'Object is not an Array.' unless a.class == Array
    a.length
  end

  def get_num_cols(a)
    raise 'Object is not a 2d Matrix.' unless a[0].class == Array
    a[0].length
  end

  def square?(a)
    raise 'Object is not an Array.' unless a.class == Array
    raise 'Object is not a 2d Matrix.' unless a[0].class == Array
    a.length == a[0].length
  end
end