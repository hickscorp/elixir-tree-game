defmodule Tree.NodeTest do
  use ExUnit.Case, async: true
  doctest Tree

  alias Tree.Node, as: Node

  setup do
    { :ok,
      tree: %{
        title: "Is it a feline?",
        yes: "Cat",
        no: %{
          title: "Is it a canine?",
          yes: %{
            title: "Can it be tammed?",
            yes: "Dog",
            no: %{
              title: "Is it known to be smart?",
              no: "Coyote",
              yes: "Fox"
            }
          },
          no: "Fish"
        }
      }
    }
  end

  test "finds a node given a path", %{tree: tree} do
    assert_zoo_healthy tree
    assert "Cat"  == Node.get tree, "y"
  end

  test "replaces nodes and leaves the rest untouched", %{tree: tree} do
    tree = Node.replace tree, "Cat", %{yes: "Tiger", no: "Cat"}

    assert_zoo_healthy tree
    assert "Cat" == Node.get tree, "yn"
    assert "Tiger" == Node.get tree, "yy"
  end

  test "doesn't touch the tree if asked to replace something not found", %{tree: tree} do
    tree = Node.replace tree, "Zebra", %{yes: "Tiger", no: "Cat"}

    assert_zoo_healthy tree
    assert "Cat"  == Node.get tree, "y"
  end

  defp assert_zoo_healthy(tree) do
    assert "Fish" == Node.get tree, "nn"
    assert "Dog" == Node.get tree, "nyy"
    assert "Fox" == Node.get tree, "nyny"
    assert "Coyote" == Node.get tree, "nynn"
  end
end
