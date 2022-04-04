# frozen_string_literal: true

# day 5
class BoardingPassProcessor
  def initialize(file)
    @data = File.readlines(file, chomp: true).map do |boarding_pass|
      [boarding_pass[0..6], boarding_pass[7..]]
    end
  end

  ROWS = (0..127).to_a.freeze
  COLS = (0..7).to_a.freeze
  SEAT_CHART = ROWS.product(COLS).freeze

  def calculate_max_seat_id
    @data.reduce(0) do |max_id, boarding_pass|
      seat_coords = boarding_pass.map(&method(:find_position))
      seat_id = calculate_seat_id.call(seat_coords)
      [seat_id, max_id].max
    end
  end

  def find_my_seat_id
    taken_seats = @data.map do |boarding_pass|
      boarding_pass.map(&method(:find_position))
    end
    taken_ids = taken_seats.map(&calculate_seat_id)
    SEAT_CHART.reject { |seat| taken_seats.include?(seat) }
              .map(&calculate_seat_id)
              .find { |id| ([id + 1, id - 1] - taken_ids).empty? }
  end

  private

  def calculate_seat_id
    ->((row_pos, col_pos)) { (row_pos * 8) + col_pos }
  end

  def find_position(instructions)
    orientation = instructions.size == 7 ? ROWS : COLS
    upper_char = orientation == ROWS ? 'F' : 'L'
    instructions.chars.reduce(orientation) do |pos, character|
      midpoint = pos.size / 2
      character == upper_char ? pos[0...midpoint] : pos[midpoint..]
    end.first
  end
end

processor = BoardingPassProcessor.new(*ARGV)

p processor.calculate_max_seat_id # -> 955
processor.find_my_seat_id # -> 569
