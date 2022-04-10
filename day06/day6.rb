# frozen_string_literal: true

# day6
class Customs
  def initialize(file_data)
    @data = File.read(file_data).split("\n\n")
  end

  def count_yes_responses
    @data.reduce(0) do |count, group|
      count + group.gsub("\n", '').chars.uniq.size
    end
  end

  def count_yes_for_everyone
    @data.reduce(0) do |count, group|
      responses = group.gsub("\n", '').chars.tally
      number_of_people = group.split("\n").size
      responses.each_value { |v| count += 1 if v == number_of_people }
      count
    end
  end
end

customs = Customs.new(*ARGV)

customs.count_yes_responses # 6735
customs.count_yes_for_everyone # 3221
