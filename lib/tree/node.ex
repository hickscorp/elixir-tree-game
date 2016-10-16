defmodule Tree.Node do
  @moduledoc """
    This module defines a tree node abstraction. A tree node can either be a
    branch or a leaf.
  """
  alias Tree.Node, as: Node

  def branch(node, "y"), do: node.yes
  def branch(node, "n"), do: node.no

  def get(n, path) when is_binary(path) do
    get n, String.graphemes path
  end
  def get(n, []) do
    n
  end
  def get(%{} = n, [choice | tail]) do
    get Node.branch(n, choice), tail
  end

  def replace(%{yes: yes, no: no} = n, old, new) do
    %{n | yes: replace(yes, old, new), no: replace(no, old, new)}
  end
  def replace(title, old, new) when title == old do
    new
  end
  def replace(title, _, _) do
    title
  end
end
