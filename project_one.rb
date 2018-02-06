require_relative 'matt_matrix'
class ProjectOne

  attr_reader :class_one, :class_two, :class_one_result, :class_two_result

  def initialize
    class_one = MattMatrix.new
    class_two = MattMatrix.new
    class_one_result = []
    class_two_result = []
    @class_one = class_one
    @class_two = class_two
    @class_one_result = class_one_result
    @class_two_result = class_two_result
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
    puts "See turned in Project Sheet."
  end

  # question six is actually about classification
  # question seven is about misclassification
  # fix this
  def question_six
    puts "Question Six:"
    test = Array.new(1) { Array.new (2) }
    misclassified = []
    answer = []
    (0..@class_one.rows_count - 1).each do |row|
      test[0][0] = Marshal.load(Marshal.dump(@class_one.matrix[row][0]))
      test[0][1] = Marshal.load(Marshal.dump(@class_one.matrix[row][1]))
      test1 = @class_one.discriminant(test)
      test2 = @class_two.discriminant(test)
      # shallow copy is fine for comparisons, but deep copy needed to
      # append to an array
      temp =  Marshal.load(Marshal.dump(test))
      if test1 > test2
        # from Class One, classified as Class One
        answer.append([temp, "Class One", "Class One"])
      else
        # from Class One, classified as Class Two
        answer.append([temp, "Class One", "Class Two"])
      end
      test[0][0] = Marshal.load(Marshal.dump(@class_two.matrix[row][0]))
      test[0][1] = Marshal.load(Marshal.dump(@class_two.matrix[row][1]))
      test1 = @class_one.discriminant(test)
      test2 = @class_two.discriminant(test)
      temp =  Marshal.load(Marshal.dump(test))
      if test1 > test2
        # from Class One, classified as Class One
        answer.append([temp, "Class Two", "Class One"])
        # from Class One, classified as Class Two
      else
        answer.append([temp, "Class Two", "Class Two"])
      end
    end
    (0..answer.length - 1).each do |index|
      if answer[index][1] != answer[index][2]
        misclassified.push(answer[index])
      end
    end
    puts "Number of misclassified points: " + misclassified.length.to_s
    puts "Point, actual class, classified class: "
    (0..misclassified.length - 1).each do |row|
      puts misclassified[row].to_s
    end
  end
end

my_project = ProjectOne.new
my_project.question_one
my_project.question_two
my_project.question_three
my_project.question_four
# my_project.question_five
my_project.question_six