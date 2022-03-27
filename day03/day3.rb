# frozen_string_literal: true

# day 3
class TreeMap
  def initialize(file_input)
    @data = File.readlines(file_input).map(&:chomp)
  end

  def count_trees_for_slope(right_step, down_step)
    x_pos = right_step * -1
    @data.to_enum.with_index.count do |_, y_pos|
      next unless (y_pos % down_step).zero?

      x_pos = (x_pos + right_step) % row_length
      @data[y_pos][x_pos] == '#'
    end
  end

  def calculate_multiple_slopes
    [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]
      .map { |coord_set| count_trees_for_slope(*coord_set) }
      .reduce(:*)
  end

  private

  def row_length
    @data[0].size
  end
end

TreeMap.new(ARGV[0]).count_trees_for_slope(3, 1) # -> 211
TreeMap.new(ARGV[0]).calculate_multiple_slopes # -> 3584591857
