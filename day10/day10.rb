# frozen_string_literal: true

input = File.readlines(*ARGV, chomp: true)
            .map(&:to_i)
            .push(0)
            .sort

input.push(input[-1] + 3)

adapter = input.each_cons(2).each_with_object(Hash.new(0)) do |(a, b), tally|
  diff = b - a
  tally[diff] += 1
end

# Part 1 Solution
p adapter[1] * (adapter[3]) # 2400

combo_counter = Hash.new(0)
combo_counter[0] = 1
input.each_with_object(combo_counter) do |n, tally|
  next if n.zero?

  tally[n] = tally[n - 1] + tally[n - 2] + tally[n - 3]
end

p combo_counter[input[-1]]
