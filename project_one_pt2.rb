load('matrix_masher.rb')

#  This is the solutions for project 1. This is a better implementation than
#  the last. Still, some mistakes were made. I think the eliminations, and the
#  determinant calculation should have been done in this file, not the
#  matrix masher module. Maybe they should be moved into a complex matrix ops
#  module.
class ProjectOnePT2
  include(MMasher)
  attr_reader :class_one, :class_two

  def initialize
    class_one = []
    class_two = []
    @class_one = class_one
    @class_two = class_two
  end

  def pull_data(fn)
    file = File.open(fn).readlines
    r = file.length
    file.each_index do |ln|
      file[ln] = file[ln].delete("\n").split("\t")
      file[ln].each_index { |i| file[ln][i] = file[ln][i].to_f }
    end
    c = file[0].length / 2 # I know I have two sets of data
    @class_one = create_matrix(r, c)
    @class_two = create_matrix(r, c)
    file.each_index do |ln|
      @class_one[ln][0] = file[ln][0]
      @class_one[ln][1] = file[ln][1]
      @class_two[ln][0] = file[ln][2]
      @class_two[ln][1] = file[ln][3]
    end
  end

  # takes an nx2 matrix, and produces 1x2 vector containing the means
  def calc_mean_vec(a)
    m = Array.new(a[0].length, 0)
    (0...a.length).each do |r|
      (0...a[0].length).each do |c|
        m[c] += a[r][c]
      end
    end
    (0...m.length).each { |i| m[i] /= a.length }
    m
  end

  # calculates a covariance matrix
  # for a nx2 set of data
  def calc_covariance(a)
    # set up:
    # we need our mean vector, and a copy of our class vector
    m = calc_mean_vec(a)
    t = Marshal.load(Marshal.dump(a))
    # a) subtract the mean vectors from the measurement vectors
    (0...t.length).each do |r|
      (0...t[0].length).each do |c|
        t[r][c] -= m[c]
      end
    end
    # b) multiply the nx1 difference vectors by their transpose
    # I really hate this, but I have to drop each vector into an array to keep
    # the transpose function happy
    sum = create_matrix(t[0].length, t[0].length)
    zero_matrix(sum)
    (0...t.length).each do |r|
      tv = [t[r]]
      tv = mult_matrices(transpose(tv), tv)
      # c) accumulate the sum of the nxn products
      sum = add_matrices(sum, tv)
    end
    # d) multiply the sum by 1/k
    mult_matrix_scalar(sum, 1 / t.length.to_f)
  end

  def calc_determinant(m)
    rexp = 0
    t = Marshal.load(Marshal.dump(m))
    (0...t.length).each do |r|
      p = calc_pivot(t, r)
      raise 'No unique solution exists.' if p == -1
      if p > r
        interchange_rows(t, r, p)
        r += 1
      end
      (r...t.length).each do |i|
        next if r == i
        tc = t[i][r] / t[r][r]
        v = Marshal.load(Marshal.dump(t))
        mult_row_constant(v, r, tc)
        (r...t[0].length).each do |c|
          t[i][c] = t[i][c] - v[r][c]
        end
      end
    end
    delta = 1
    (0...t.length).each do |r|
      delta *= t[r][r]
    end
    delta *= (-1)**rexp
  end

  def calc_inverse(m)
    i = Marshal.load(Marshal.dump(m))
    augment_with_identity(i)
    i = gauss_jordan_elim(i)
    strip_identity(i)
    i
  end

  def classify(v)
    c1 = calc_discriminant(v, @class_one)
    c2 = calc_discriminant(v, @class_two)
    if(c1 > c2)
      'Class One'
    else
      'Class Two'
    end
  end

  # v = vector to test
  # dc = data class
  # dcc = data class covariance matrix
  # dccd = data class covariance matrix determinant
  # dcci = data class covariance matrix inverse
  # l1 = the first logarithm, (lower case l and number one)
  # l2 = the second logarithm
  # m = mean vector for the class
  def calc_discriminant(v, dc)
    dcc = calc_covariance(dc)
    dccd = calc_determinant(dcc)
    dcci = calc_inverse(dcc)
    l1 = 0.5 * Math.log(dccd)
    l2 = Math.log(0.5)
    m = calc_mean_vec(dc)
    # matrix masher expects vectors to be matrices
    # with a zero row
    v = [v]
    m = [m]
    v = sub_matrices(v, m)
    v2 = mult_matrices(v, dcci)
    v = transpose(v)
    v3 = mult_matrices(v2, v)
    v3 = mult_matrix_scalar(v3, -0.5)
    d = v3[0][0]
    d -= l1
    d += l2
    d
  end

  def q1
    puts 'Question 1:'
    pull_data('data.txt')
    puts 'The mean vector for Class One is: ' + calc_mean_vec(@class_one).to_s
    puts 'The mean vector for Class Two is: ' + calc_mean_vec(@class_two).to_s
  end

  def q2
    puts 'Question 2:'
    c1 = calc_covariance(@class_one)
    c2 = calc_covariance(@class_two)
    puts 'The covariance matrix for Class One is: '
    print_matrix(c1)
    puts''
    puts 'The covariance matrix for Class Two is: '
    print_matrix(c2)
  end

  def q3
    puts 'Question 3:'
    c1 = calc_covariance(@class_one)
    c2 = calc_covariance(@class_two)
    puts 'The determinant for Class One is: ' + calc_determinant(c1).to_s
    puts 'The determinant for Class Two is: ' + calc_determinant(c2).to_s
  end

  def q4
    puts 'Question 4:'
    c1 = calc_covariance(@class_one)
    c2 = calc_covariance(@class_two)
    augment_with_identity(c1)
    augment_with_identity(c2)
    c1 = gauss_jordan_elim(c1)
    c2 = gauss_jordan_elim(c2)
    strip_identity(c1)
    strip_identity(c2)
    puts 'The inverse of the covariance matrix for Class One: '
    print_matrix(c1)
    puts 'The inverse of the covariance matrix for Class Two: '
    print_matrix(c2)
  end

  def q5
    puts 'Question 5 is included on the submitted test document.'
  end

  def q6
    puts 'Question 6:'
    # we're running the mean vectors through the classifier, to see which
    # class it classifies them as
    m1 = calc_mean_vec(@class_one)
    m2 = calc_mean_vec(@class_two)
    puts 'The mean of Class One is classified as ' + classify(m1)
    puts 'The mean of Class Two is classified as ' + classify(m2)
  end

  def q7
    puts 'Question 7:'
    # class one
    (0...@class_one.length).each do |v|
      if(classify(@class_one[v]) == 'Class Two')
        puts 'Class One point ' + @class_one[v].to_s + ' misclassified.'
        puts 'Class One determinant: ' + calc_discriminant(@class_one[v], @class_one).to_s
        puts 'Class Two determinant: ' + calc_discriminant(@class_one[v], @class_two).to_s
      end
    end
    puts ''
    (0...@class_one.length).each do |v|
      if(classify(@class_two[v]) == 'Class One')
        puts 'Class Two point ' + @class_two[v].to_s + ' misclassified.'
        puts 'Class One determinant: ' + calc_discriminant(@class_two[v], @class_one).to_s
        puts 'Class Two determinant: ' + calc_discriminant(@class_two[v], @class_two).to_s
      end
    end
  end

  def q8

  end

  def q9
    puts 'Question 9:'
    m = create_matrix(8, 9)
    m[0] = [2.0,  1.0,  -1.0, -1.0, 1.0,  0.0,  -1.0, -1.0, 1.0]
    m[1] = [1.0,  0.0,  2.0,  0.0,  -1.0, -2.0, 2.0,  2.0,  -1.0]
    m[2] = [0.0,  -2.0, 5.0,  4.0,  -1.0, 0.0,  3.0,  1.0,  2.0]
    m[3] = [1.0,  1.0,  -7.0, 3.0,  2.0,  1.0,  -1.0, 0.0,  -2.0]
    m[4] = [1.0,  1.0,  2.0,  3.0,  -2.0, 2.0,  2.0,  9.0,  3.0]
    m[5] = [0.0,  -3.0, -2.0, 2.0,  0.0,  2.0,  4.0,  -5.0, -3.0]
    m[6] = [-2.0, 5.0,  -1.0, 1.0,  1.0,  3.0,  0.0,  -2.0, 4.0]
    m[7] = [1.0,  0.0,  1.0,  1.0,  0.0,  2.0,  1.0,  1.0,  -4.0]
    m = gauss_jordan_elim(m)
    print_matrix(m)
  end

  def q10

  end
end

my_project = ProjectOnePT2.new
my_project.q1
puts ''
my_project.q2
puts ''
my_project.q3
puts ''
my_project.q4
puts ''
my_project.q5
puts ''
my_project.q6
puts ''
my_project.q7
puts ''
puts 'Skipping question 8.'
my_project.q9
puts ''
my_project.q10
