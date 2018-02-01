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
end

my_project = ProjectOne.new
my_project.question_one
my_project.question_two

