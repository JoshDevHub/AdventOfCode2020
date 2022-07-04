# frozen_string_literal: true

class Bag
  attr_reader :type, :children

  def initialize(type, children)
    @type = type
    @children = populate_children(children)
  end

  def populate_children(children)
    children.map do |child|
      if child.start_with?("no")
        {}
      else
        parsed_string = /^.*(?=( bag))/.match(child)[0]
        { number: parsed_string[0].to_i, type: parsed_string[2..] }
      end
    end
  end

  def shiny_gold_type?
    @type == "shiny gold"
  end

  def children_contain?(type)
    @children.any? { |child| child&.value?(type) }
  end
end

data = File.readlines(*ARGV, chomp: true)
           .map do |line|
             type, children = line.split(" bags contain ")
             Bag.new(type, children.split(", "))
           end

# Part 1: gold bag ancestor BFS
queue = data.select { |bag| bag.children_contain?("shiny gold") }
shiny_gold_parents = [*queue]
until queue.empty?
  current_bag = queue.shift
  current_bag_parents = data.select { |bag| bag.children_contain?(current_bag.type) }
  shiny_gold_parents += current_bag_parents
  queue += current_bag_parents
end
shiny_gold_parents.uniq.size # 235

# Part 2: gold bag descendant DFS
shiny_gold = data.find(&:shiny_gold_type?)
def descendant_count(data, children, parent_count = 1)
  return 0 if children.empty?

  children.reduce(0) do |count, child|
    next(count) if child.empty?

    grandchildren = data.find { |bag| bag.type == child[:type] }.children
    in_chain_total = child[:number] * parent_count
    count + in_chain_total + descendant_count(data, grandchildren, in_chain_total)
  end
end

descendant_count(data, shiny_gold.children) # 158493
