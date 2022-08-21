# frozen_string_literal: true

require "set"
require "debug"

class Day8
  def initialize(input)
    @input = input.is_a?(String) ? File.readlines(input, chomp: true) : input
    @accumulator = 0
  end

  def final_accumulator_val
    visited = Set.new
    pointer = 0
    loop do
      op, arg = @input[pointer].split
      return @accumulator if visited.include?(pointer)

      visited << pointer
      instruction = Instruction.new(op, arg.to_i)
      @accumulator = instruction.operate(@accumulator)
      pointer = instruction.jump_from(pointer)
      return @accumulator if pointer >= @input.length
    end
  end

  def corrected_acc
    instructions = find_correct_instructions
    self.class.new(instructions).final_accumulator_val
  end

  def find_correct_instructions
    pointer = 0
    loop do
      op, arg = @input[pointer].split
      if op == "acc"
        pointer += 1
        next
      end
      replacement_op = op == "jmp" ? "nop" : "jmp"
      temp = @input.clone
      temp[pointer] = "#{replacement_op} #{arg}"
      return temp unless infinite_loop?(temp)

      pointer += 1
    end
  end

  def infinite_loop?(instructions)
    visited = Set.new
    pointer = 0
    loop do
      return false if pointer >= instructions.length

      op, arg = instructions[pointer].split
      return true if visited.include?(pointer)

      visited << pointer
      instruction = Instruction.new(op, arg.to_i)
      pointer = instruction.jump_from(pointer)
    end
  end
end

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

Day8.new(*ARGV).final_accumulator_val # 1876

Day8.new(*ARGV).corrected_acc # 1303
