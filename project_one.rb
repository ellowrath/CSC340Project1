require_relative 'matt_matrix'
class ProjectOne

  attr_reader :class_one, :class_two, :m_one, :m_two

  def initialize
    m_one = []
    m_two = []
    class_one = MattMatrix.new
    class_two = MattMatrix.new
    @class_one = class_one
    @class_two = class_two
    @m_one = m_one
    @m_two = m_two
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
    pull_data'data.txt'
    @class_one.calc_mean_vectors
    @class_two.calc_mean_vectors
    puts @class_one.means.to_s
    puts @class_two.means.to_s
  end

  def question_two
    sub_class_one = []
    sub_class_two = []
    sum1 = 0.0
    sum2 = 0.0
    (0..@class_one.length - 1).each do |row|
      sub_class_one[row] = @class_one[row].map { |e| e.dup }
      sub_class_two[row] = @class_two[row].map { |e| e.dup }
      (0..sub_class_one[row].length - 1).each do |cell|
        sub_class_one[row][cell] -= @m_one[cell]
        sub_class_two[row][cell] -= @m_two[cell]
      end
    end
    (0..@class_one.length - 1).each do |row|
      temp1 = MattMatrix.new(2, 1)
      temp2 = MattMatrix.new(2, 1)
      temp1.matrix[0][0] = sub_class_one[row][0]
      temp2.matrix[0][0] = sub_class_two[row][0]
      temp1.matrix[1][0] = sub_class_one[row][1]
      temp2.matrix[1][0] = sub_class_two[row][1]
      temp1.calc_covariance
      temp2.calc_covariance
      # sum1 += temp1.matrix[0][0]
      # sum2 += temp2.matrix[0][0]
    end
    # puts sum1.to_s
    # puts sum2.to_s
    # sum1 /= 110
    # sum2 /= 110
    # puts sum1.to_s
    # puts sum2.to_s
  end
end

my_project = ProjectOne.new
my_project.question_one
# my_project.question_two

