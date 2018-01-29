require_relative 'matt_matrix'
class ProjectOne

  attr_accessor :class_one, :class_two

  def initialize
    @class_one = class_one
    @class_two = class_two
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

  def print_data
    puts 'class_one length: ' + @class_one.length.to_s
    puts 'class_two length: ' + @class_two.length.to_s
    (0..@class_one.length - 1).each { |row| puts @class_one[row].to_s + ' ' + @class_two[row].to_s }
  end
end

my_project = ProjectOne.new
my_project.pull_data('data.txt')
my_project.print_data

