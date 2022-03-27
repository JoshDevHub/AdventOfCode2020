# frozen_string_literal: true

# Day 1 Advent of Code
class ExpenseReport
  def initialize(input)
    @data = File.readlines(input).map(&:to_i)
  end

  def two_part_sum
    find_sum_to2020(2).reduce(:*)
  end

  def three_part_sum
    find_sum_to2020(3).reduce(:*)
  end

  private

  def find_sum_to2020(parts)
    @data.combination(parts).find { |combo| combo.sum == 2020 }
  end
end

ExpenseReport.new(ARGV[0]).two_part_sum # -> 691771

ExpenseReport.new(ARGV[0]).three_part_sum # -> 232508760
