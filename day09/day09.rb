# frozen_string_literal: true

class Day9
  def initialize(file)
    @input = File.readlines(file, chomp: true).map(&:to_i)
  end

  PREAMBLE = 26

  def find_invalid_number
    @input.each_cons(PREAMBLE) do |(*first, last)|
      return last unless first.combination(2).any? { |c| c.sum == last }
    end
  end

  def find_encryption_weakness
    lower_i, upper_i = find_contiguous_sum_indices
    @input[lower_i..upper_i].minmax.sum
  end

  def find_contiguous_sum_indices
    target = find_invalid_number
    @input.each_index do |i|
      running_sum = 0
      @input[i..].each_with_index do |n, j|
        running_sum += n
        return [i, j + i] if running_sum == target
        break if running_sum > target || running_sum == target
      end
    end
  end
end

solution = Day9.new(*ARGV)

solution.find_invalid_number # 15690279
solution.find_encryption_weakness # 2174232
