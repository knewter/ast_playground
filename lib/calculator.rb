require_relative './arithmetics_processor'
require 'pry'
# This Processor folds nonterminal nodes and returns an (integer)
# terminal node.
class Calculator < ArithmeticsProcessor
  def compute_op(node)
    # First, node children are processed and then unpacked to local
    # variables.
    nodes = process_all(node)
    binding.pry

    if nodes.all? { |node| node.type == :integer }
      # If each of those nodes represents a literal, we can fold this
      # node!
      values = nodes.map { |node| node.children.first }
      AST::Node.new(:integer, [
        yield(values)
      ])
    else
      # Otherwise, we can just leave the current node in the tree and
      # only update it with processed children nodes, which can be
      # partially folded.
      node.updated(nil, nodes)
    end
  end

  def on_add(node)
    compute_op(node) { |left, right| left + right }
  end

  def on_multiply(node)
    compute_op(node) { |left, right| left * right }
  end
end
