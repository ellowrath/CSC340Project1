load('matrix_masher.rb')
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
    tva

  end

  def q1
    pull_data('data.txt')
    puts 'The mean vector for Class One is: ' + calc_mean_vec(@class_one).to_s
    puts 'The mean vector for Class Two is: ' + calc_mean_vec(@class_two).to_s
  end

  def q2


  end
end

my_project = ProjectOnePT2.new
my_project.q1
