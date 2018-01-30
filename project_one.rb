require_relative 'matt_matrix'
class ProjectOne

  attr_reader :class_one, :class_two, :m_one, :m_two

  def initialize
    m_one = []
    m_two = []
    @class_one = class_one
    @class_two = class_two
    @m_one = m_one
    @m_two = m_two
  end

  def pull_data(file_name)
    file = File.open(file_name).readlines
    file.each_index do |line|
      file[line] = file[line].delete("\n").split("\t")
      file[line].each_index { |index| file[line][index] = file[line][index].to_f }
    end
    @class_one = Array.new(file.length){ Array.new(2) }
    @class_two = Array.new(file.length){ Array.new(2) }
    file.each_index do |line|
      @class_one[line][0] = file[line][0]
      @class_one[line][1] = file[line][1]
      @class_two[line][0] = file[line][2]
      @class_two[line][1] = file[line][3]
    end
  end

  def calc_mean_vectors
    sum_one_one = 0.0
    sum_one_two = 0.0
    sum_two_one = 0.0
    sum_two_two = 0.0
    (0..class_one.length - 1).each do |row|
      sum_one_one += @class_one[row][0]
      sum_one_two += @class_one[row][1]
      sum_two_one += @class_two[row][0]
      sum_two_two += @class_two[row][1]
    end
    @m_one[0] = sum_one_one / @class_one.length
    @m_one[1] = sum_one_two / @class_one.length
    @m_two[0] = sum_two_one / @class_two.length
    @m_two[1] = sum_two_two / @class_two.length
  end

  def print_all_data
    puts 'class_one length: ' + @class_one.length.to_s
    puts 'class_two length: ' + @class_two.length.to_s
    (0..@class_one.length - 1).each { |row| puts @class_one[row].to_s + ' ' + @class_two[row].to_s }
    puts 'mean for class one, : ' + @m_one.to_s
    puts 'mean for class two: ' + @m_two.to_s
  end

  def question_one
    pull_data'data.txt'
    calc_mean_vectors
    puts 'mean for class one, : ' + @m_one.to_s
    puts 'mean for class two: ' + @m_two.to_s
  end

  def question_two
    sub_class_one = []
    sub_class_two = []
    cov_mat_one_one = MattMatrix.new
    cov_mat_one_two = MattMatrix.new
    cov_mat_two_one = MattMatrix.new
    cov_mat_two_two = MattMatrix.new
    cov_mat_one_one.build(@class_one.length, 1)
    cov_mat_one_two.build(@class_one.length, 1)
    cov_mat_two_one.build(@class_two.length, 1)
    cov_mat_two_two.build(@class_two.length, 1)
    # create the difference vectores
    (0..@class_one.length - 1).each do |row|
      sub_class_one[row] = @class_one[row].map { |e| e.dup }
      sub_class_two[row] = @class_two[row].map { |e| e.dup }
      (0..sub_class_one[row].length - 1).each do |cell|
        sub_class_one[row][cell] -= @m_one[cell]
        sub_class_two[row][cell] -= @m_two[cell]
      end
    end
    # put the difference vectors into MattMatrices
    (0..@class_one.length - 1).each do |cell|
      cov_mat_one_one.matrix[cell] = sub_class_one[cell][0]
      cov_mat_one_two.matrix[cell] = sub_class_one[cell][1]
      cov_mat_two_one.matrix[cell] = sub_class_two[cell][0]
      cov_mat_two_one.matrix[cell] = sub_class_two[cell][1]
    end
    puts cov_mat_one_one.rows_count
    puts cov_mat_one_one.cols_count
    cov_mat_one_one.calc_covariance

  end
end

my_project = ProjectOne.new
my_project.question_one
my_project.question_two

