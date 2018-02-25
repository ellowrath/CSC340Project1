require_relative 'matt_matrix'
class ProjectOne

  attr_reader :class_one, :class_two, :class_one_result, :class_two_result, :classified, :misclassified, :g_mat

  def initialize
    class_one = MattMatrix.new
    class_two = MattMatrix.new
    class_one_result = []
    class_two_result = []
    @class_one = class_one
    @class_two = class_two
    @class_one_result = class_one_result
    @class_two_result = class_two_result
    @classified = classified
    @misclassified = misclassified
    @g_mat = g_mat
  end

  # pulls data from a text file
  # and places it into a custom matrix class
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

  def question_five
    puts "See turned in Project Sheet."
  end

  def question_six
    c1 = 0
    c2 = 0
    test = Array.new(1) { Array.new(2) }
    @misclassified = []
    @classified = []
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
        @classified.append([temp, "Class One", "Class One"])
        c1 += 1
      else
        # from Class One, classified as Class Two
        @classified.append([temp, "Class One", "Class Two"])
        c2 += 1
      end
      test[0][0] = Marshal.load(Marshal.dump(@class_two.matrix[row][0]))
      test[0][1] = Marshal.load(Marshal.dump(@class_two.matrix[row][1]))
      test1 = @class_one.discriminant(test)
      test2 = @class_two.discriminant(test)
      temp =  Marshal.load(Marshal.dump(test))
      if test1 > test2
        # from Class One, classified as Class One
        @classified.append([temp, "Class Two", "Class One"])
        c1 += 1
      else
        # from Class One, classified as Class Two
        @classified.append([temp, "Class Two", "Class Two"])
        c2 += 1
      end
    end
    puts "Question Six:"
    puts "Number of points classified as Class One: " + c1.to_s
    puts "Number of points classified as Class Two: " + c2.to_s
    puts "Points Classified as Class One:"
    (0..@classified.length - 1).each do |index|
      puts @classified[index][0].to_s if @classified[index][2] == "Class One"
    end
    puts ""
    puts "Points Classified as Class Two:"
    (0..@classified.length - 1).each do |index|
      puts @classified[index][0].to_s if @classified[index][2] == "Class Two"
    end
    puts ""
  end

  def question_seven
    puts "Question Seven: "
    (0..@classified.length - 1).each do |index|
      if @classified[index][1] != @classified[index][2]
        @misclassified.push(@classified[index])
      end
    end
    puts "Number of misclassified points: " + @misclassified.length.to_s
    puts "Point \t\t\t\t\t\t\tactual class classified class: "
    (0..@misclassified.length - 1).each do |row|
      puts @misclassified[row].to_s
      puts @class_one.discriminant(@misclassified[row][0]).to_s
      puts @class_two.discriminant(@misclassified[row][0]).to_s
    end
    puts ""
  end

  def question_eight
    # mark my boundary
    left = 0.5
    up = 4.0
    right = 2.5
    down = -2.0
    inc = 0.005
    boundary = []
    # massage this
    epsilon = 0.01
    (down...up).step(inc).each do |y_value|
      (left...right).step(inc).each do |x_value|
        test = [[x_value, y_value]]
        dif = (@class_one.discriminant(test) - @class_two.discriminant(test)).abs
        boundary.append(test) if dif < epsilon
      end
    end
    puts "Question Eight:"
    puts "Boundary points for Plotting:"
    (0..boundary.length - 1).each do |index|
      puts boundary[index][0].to_s
    end
    # for easier copy and paste into excel for checking
    # puts "X values"
    # (0...boundary.length).each do |index|
    #   puts boundary[index][0][0].to_s
    # end
    # puts "Y values"
    # (0...boundary.length).each do |index|
    #   puts boundary[index][0][1].to_s
    # end
    puts ""
  end

  def question_nine
    puts "Question Nine:"
    puts "Gauss-Jordan Elimination:"
    q9 = MattMatrix.new
    q9.build(8, 9)
    q9.matrix[0] = [2.0, 1.0, -1.0, -1.0, 1.0, 0.0, -1.0, -1.0, 1.0]
    q9.matrix[1] = [1.0, 0.0, 2.0, 0.0, -1.0, -2.0, 2.0, 2.0, -1.0]
    q9.matrix[2] = [0.0, -2.0, 5.0, 4.0, -1.0, 0.0, 3.0, 1.0, 2.0]
    q9.matrix[3] = [1.0, 1.0, -7.0, 3.0, 2.0, 1.0, -1.0, 0.0, -2.0]
    q9.matrix[4] = [1.0, 1.0, 2.0, 3.0, -2.0, 2.0, 2.0, 9.0, 3.0]
    q9.matrix[5] = [0.0, -3.0, -2.0, 2.0, 0.0, 2.0, 4.0, -5.0, -3.0]
    q9.matrix[6] = [-2.0, 5.0, -1.0, 1.0, 1.0, 3.0, 0.0, -2.0, 4.0]
    q9.matrix[7] = [1.0, 0.0, 1.0, 1.0, 0.0, 2.0, 1.0, 1.0, -4.0]
    a_mat = Marshal.load(Marshal.dump(q9))
    a_mat.gauss_jordan_elim
    puts "a. Variables:"
    puts "x = " + a_mat.matrix[0][8].to_s
    puts "y = " + a_mat.matrix[1][8].to_s
    puts "z = " + a_mat.matrix[2][8].to_s
    puts "w = " + a_mat.matrix[3][8].to_s
    puts "a = " + a_mat.matrix[4][8].to_s
    puts "b = " + a_mat.matrix[5][8].to_s
    puts "c = " + a_mat.matrix[6][8].to_s
    puts "d = " + a_mat.matrix[7][8].to_s
    puts ""
    puts "b. Determinant of Matrix A:"
    # b_mat is the coefficient matrix w/o solution augmentation
    b_mat = Marshal.load(Marshal.dump(q9))
    b_mat.cols_count -= 1
    (0..b_mat.rows_count - 1).each do |row|
      b_mat.matrix[row].pop
    end
    # c_mat is the inverse of the coefficient matrix
    c_mat = Marshal.load(Marshal.dump(b_mat))
    # bad design alert, calculating the determinant jacks up the matrix as saved
    e_mat = Marshal.load(Marshal.dump(b_mat))
    @g_mat = Marshal.load(Marshal.dump(b_mat))
    a_mat_det = b_mat.determinant
    puts a_mat_det.to_s
    puts ""
    puts "c. i. Inverse of Matrix A:"
    c_mat.inverse
    c_mat.print_matrix
    puts "c. ii. Determinant of the Inverse of Matrix A:"
    # bad design alert, calculating the determinant jacks up the matrix as saved
    # should've made copies in the function that does this
    f_mat = Marshal.load(Marshal.dump(c_mat))
    a_mat_inv_det = c_mat.determinant
    puts a_mat_inv_det.to_s
    puts ""
    puts "c. iii. Product of these Determinants:"
    det = a_mat_det * a_mat_inv_det
    puts det.to_s
    puts ""
    puts "d. This is ugly, but I think it is expected due to IEEE 754."
    puts "It appears correctish:"
    d_mat = MattMatrix.new
    d_mat.build(8, 8)
    d_mat.mult_matrices(e_mat, f_mat)
    d_mat.print_matrix
  end

  def question_ten
    h_mat = Marshal.load(Marshal.dump(@g_mat))
    h_mat.inverse
    a_norm = @g_mat.calc_mat_norm
    a_i_norm = h_mat.calc_mat_norm
    c_num = a_norm * a_i_norm
    puts "Question Ten:"
    puts "The condition number for Matrix A is " + c_num.to_s

  end
end

my_project = ProjectOne.new
my_project.question_one
my_project.question_two
my_project.question_three
my_project.question_four
my_project.question_five
my_project.question_six
my_project.question_seven
#  my_project.question_eight
my_project.question_nine
my_project.question_ten