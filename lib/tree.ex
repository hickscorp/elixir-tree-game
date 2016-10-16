defmodule Tree do
  use Application

  alias Tree.Node, as: Node

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = []
    opts = [strategy: :one_for_one, name: Tree.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def loop do
    loop read_data
  end

  def loop(%{} = root_node) do
    root_node = game root_node, root_node
    File.write! "tree.bin", :erlang.term_to_binary(root_node)
    loop root_node
  end

  def game(%{} = root_node, %{} = current_node) do
    answer = gets current_node.title
    next_node = Node.branch current_node, answer
    game root_node, next_node
  end
  def game(%{} = root_node, result) when is_binary(result) do
    answer = gets("The solution is #{result}!")
    game_over answer, root_node, result
  end

  defp game_over("y", %{} = root_node, _) do
    root_node
  end
  defp game_over(_, %{} = root_node, result) when is_binary(result) do
    answer = gets "What was your thing?"
    question = gets "Input a question that would be true for #{answer} but false for #{result}."
    Node.replace root_node, result, %{title: question, yes: answer, no: result}
  end

  def read_data do
    case File.read "tree.bin" do
      {:ok, bin} -> :erlang.binary_to_term bin
      _ -> %{title: "Is it alive?", yes: "cat", no: "cup"}
    end
  end

  defp gets(message) do
    IO.gets("#{message} > ") |> String.strip
  end
end
