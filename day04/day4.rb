# frozen_string_literal: true

# day4
class PasswordProcessor
  def initialize(file, validator)
    @data = File.read(file).split("\n\n").map do |passport|
      passport.gsub("\n", ' ').split.each_with_object({}) do |field, obj|
        key, value = field.split(':')
        obj[key.to_sym] = value
        obj
      end
    end
    @validator = validator
  end

  VALID_FIELDS = %i[byr iyr eyr hgt hcl ecl pid].freeze

  def count_valid_fields
    @data.count { |passport| VALID_FIELDS.difference(passport.keys).none? }
  end

  def count_valid_passports
    @data.count do |passport|
      VALID_FIELDS.difference(passport.keys).none? &&
        passport.all? { |(field, info)| @validator.field_is_valid?(field, info) }
    end
  end
end

class Validator
  def initialize(field, info)
    @field = field
    @info = info
  end

  def self.field_is_valid?(field, info)
    new(field, info).send(field)
  end

  private

  attr_reader :field, :info

  def byr
    info.between?('1920', '2002')
  end

  def iyr
    info.between?('2010', '2020')
  end

  def eyr
    info.between?('2020', '2030')
  end

  def hgt
    unit = info[-2..].to_sym
    {
      cm: info[0..2].between?('150', '193'),
      in: info[0..1].between?('59', '76')
    }[unit]
  end

  def hcl
    info.match?(/^#[[:xdigit:]]{6}$/)
  end

  def ecl
    %w[amb blu brn gry grn hzl oth].include?(info)
  end

  def pid
    info.match?(/^[[:digit:]]{9}$/)
  end

  def cid
    true
  end
end

processor = PasswordProcessor.new(*$*, Validator)

p processor.count_valid_fields # -> 247
p processor.count_valid_passports # -> 145
