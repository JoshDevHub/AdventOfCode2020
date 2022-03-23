# frozen_string_literal: true

# Day 2 Advent of Code
class PasswordValidator
  def initialize(input)
    @data = File.readlines(input).map do |line|
      range, letter, password = line.split
      min, max = range.split('-').map(&:to_i)
      { min: min, max: max, letter: letter[0], password: password }
    end
  end

  def count_valid_sled_passwords
    @data.count do |password_set|
      password_set => { min:, max:, letter:, password: }
      letter_count = password.count(letter)
      letter_count.between?(min, max)
    end
  end

  def count_valid_toboggan_password
    @data.count do |password_set|
      password_set => { min:, max:, letter:, password: }
      first_idx, second_idx = [min, max].map(&:pred)
      [password[first_idx], password[second_idx]]
        .one?(&letter.method(:==))
    end
  end
end

PasswordValidator.new(ARGV[0]).count_valid_sled_passwords # -> 636

PasswordValidator.new(ARGV[0]).count_valid_toboggan_password # -> 588
