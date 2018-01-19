require_relative 'matt_matrix'

class Driver

  def go
    my_matrix = MattMatrix.new

    puts my_matrix.class
    p my_matrix
    my_matrix.make_identity
    p my_matrix

  end
end

my_driver = Driver.new
my_driver.go
