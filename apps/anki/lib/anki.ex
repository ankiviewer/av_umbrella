defmodule Anki do
  @moduledoc"""
  Core library
  Currently just for interacting with node application
  """
  require Poison
  require HTTPoison

  @root_url "http://localhost:4444"

  def json_model,
    do: "#{__DIR__}/../node_app/test/models.json"

  defp kill_node,
    do: System.cmd "pkill", ["node"]

  defp node_result(pid, endpoint) when is_binary endpoint do
    receive do
      {^pid, :data, :out, log} ->
        IO.puts "Node log => #{log}"
        if log =~ "running",
          do: HTTPoison.get!(@root_url <> endpoint),
          else: node_result pid, endpoint
    end
  end

  @doc"""
  What to request from the node server
  Example:
  Anki.request "/collection"
  Anki.request "/notes"
  """
  def request!(endpoint) when is_binary endpoint do
    kill_node()
    System.put_env "NODE_ENV", "#{Mix.env}"
    cmd = "node #{__DIR__}/../node_app/src/index.js"
    opts = [out: {:send, self()}]
    %Porcelain.Process{pid: pid} = Porcelain.spawn_shell cmd, opts

    IO.inspect pid

    result = node_result pid, endpoint

    {"", 0} = kill_node()

    with %HTTPoison.Response{body: body} <- result, do: Poison.decode! body
  end
end
