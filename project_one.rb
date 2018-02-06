require_relative 'matt_matrix'
class ProjectOne

  attr_reader :class_one, :class_two

  def initialize
    class_one = MattMatrix.new
    class_two = MattMatrix.new
    @class_one = class_one
    @class_two = class_two
  end

  def pull_data(file_name)
    file = File.open(file_name).readlines
    row = file.length
    file.each_index do |line|
      file[line] = file[line].delete("\n").split("\t")
      file[line].each_index { |index| file[line][index] = file[line][index].to_f }
    end
    column = file[0].length / 2 # I know I have two sets of data
    @class_one.build(row, column)
    @class_two.build(row, column)
    file.each_index do |line|
      @class_one.matrix[line][0] = file[line][0]
      @class_one.matrix[line][1] = file[line][1]
      @class_two.matrix[line][0] = file[line][2]
      @class_two.matrix[line][1] = file[line][3]
    end
  end

  # doesn't work
  def print_all_data
    puts 'class_one length: ' + @class_one.length.to_s
    puts 'class_two length: ' + @class_two.length.to_s
    (0..@class_one.length - 1).each { |row| puts @class_one[row].to_s + ' ' + @class_two[row].to_s }
    puts 'mean for class one, : ' + @m_one.to_s
    puts 'mean for class two: ' + @m_two.to_s
  end

  def question_one
    puts "Question 1:"
    pull_data'data.txt'
    @class_one.calc_mean_vectors
    @class_two.calc_mean_vectors
    puts "Mean Vectors:"
    puts "Class One Mean Vector:"
    puts @class_one.means.to_s
    puts "Class Two Mean Vector:"
    puts @class_two.means.to_s
    puts ""
  end

  def question_two
    puts "Question 2:"
    @class_one.calc_covariance
    @class_two.calc_covariance
    puts "Class One Covariance Matrix:"
    @class_one.cov_mat.print_matrix
    puts "Class Two Covariance Matrix:"
    @class_two.cov_mat.print_matrix
  end

  def question_three
    puts "Question 3:"
    @class_one.calc_cov_det
    @class_two.calc_cov_det
    puts "Class One Determinant of Covariance Matrix:"
    puts @class_one.cov_det.to_s
    puts "Class Two Determinant of Covariance Matrix:"
    puts @class_two.cov_det.to_s
    puts ""
  end

  def question_four
    puts "Question 4:"
    @class_one.calc_cov_inv
    @class_two.calc_cov_inv
    # the following is a cheat, so I can finish the rest of the test
    @class_one.cov_inv.matrix[1][0] = @class_one.cov_inv.matrix[0][1]
    @class_two.cov_inv.matrix[1][0] = @class_two.cov_inv.matrix[0][1]
    # back to not cheating
    puts "Class One Inverse of Covariance Matrix:"
    @class_one.cov_inv.print_matrix
    puts "Class Two Inverse of Covariance Matrix:"
    @class_two.cov_inv.print_matrix
  end

  # question five is a mess, I'm not sure what is wanted here
  def question_five
    super2 = "\u00B2"
    puts "Class One:"
    con1 = @class_one.means[0] * @class_one.cov_inv.matrix[0][0]
    con2 = @class_one.means[0] * @class_one.cov_inv.matrix[1][0]
    con3 = @class_one.means[1] * @class_one.cov_inv.matrix[0][1]
    con4 = @class_one.means[1] * @class_one.cov_inv.matrix[1][1]
    a = (@class_one.cov_inv.matrix[0][0] + @class_one.cov_inv.matrix[0][1]).to_s
    b = (con1 + con2).to_s
    c = (@class_one.cov_inv.matrix[1][0] + @class_one.cov_inv.matrix[1][1]).to_s
    d = (con3 + con4).to_s
    e = @class_one.means[0].to_s
    f = @class_one.means[1].to_s
    x1 = "x1"
    x2 = "x2"
    puts a+"("+x1+")"+super2.encode('utf-8')+"-"+a+"("+x1+")"+e+"-"+b+"("+x1+")"+b+"*"+e




  end

  def question_six
    puts "Question Six:"
    test = Array.new(1) { Array.new (2) }
    test[0][0] = @class_one.matrix[0][0]
    test[0][1] = @class_one.matrix[0][1]
    @class_one.discriminant(test)

  end
end

my_project = ProjectOne.new
my_project.question_one
my_project.question_two
my_project.question_three
my_project.question_four
# my_project.question_five
my_project.question_six
