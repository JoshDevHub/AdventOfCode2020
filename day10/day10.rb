# frozen_string_literal: true

input = File.readlines(*ARGV, chomp: true)
            .map(&:to_i)
            .sort
            .unshift(0)

adapter = input.each_cons(2).each_with_object(Hash.new(0)) do |(a, b), tally|
  diff = b - a
  tally[diff] += 1
end

p adapter[1] * (adapter[3] + 1)
