# frozen_string_literal: true

require "set"

input = File.readlines(*ARGV, chomp: true)

class Instruction
  def initialize(operation, argument)
    @operation = operation
    @argument = argument
  end

  def operate(accumulator)
    accumulator + (@operation == "acc" ? @argument : 0)
  end

  def jump_from(pointer)
    pointer + (@operation == "jmp" ? @argument : 1)
  end
end

pointer = 0
visited = Set.new
accumulator = 0

part_one = loop do
  op, arg = input[pointer].split
  break accumulator if visited.include?(pointer)

  visited << pointer
  instruction = Instruction.new(op, arg.to_i)
  accumulator = instruction.operate(accumulator)
  pointer = instruction.jump_from(pointer)
end

p part_one # 1876
