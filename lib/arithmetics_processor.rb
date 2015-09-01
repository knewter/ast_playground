require 'ast'

class ArithmeticsProcessor < AST::Processor
  # This method traverses any binary operators such as (add) or (multiply).
  def process_binary_op(node)
    # Children aren't decomposed automatically; it is suggested to use Ruby
    # multiple assignment expansion, as it is very convenient here.
    left_expr, right_expr = *node

    # AST::Node#updated won't change node type if nil is passed as a first
    # argument, which allows to reuse the same handler for multiple node types
    # using `alias' (below).
    node.updated(nil, [
      process(left_expr),
      process(right_expr)
    ])
  end
  alias on_add      process_binary_op
  alias on_multiply process_binary_op
  alias on_divide   process_binary_op

  def on_negate(node)
    # It is also possible to use #process_all for more compact code
    # if every child is a Node.
    node.updated(nil, process_all(node))
  end

  def on_store(node)
    expr, variable_name = *node

    # Note that variable_name is not a Node and thus isn't passed to #process.
    node.updated(nil, [
      process(expr),
      variable_name
    ])
  end

  # (load) is effectively a terminal node, and so it does not need
  # an explicit handler, as the following is the default behavior.
  def on_load(node)
    nil
  end

  def on_each(node)
    node.updated(nil, process_all(node))
  end
end
