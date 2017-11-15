defmodule Anki do
  require Poison
  require HTTPoison

  @root_url "http://localhost:4444"

  defp kill_node(), do: System.cmd "pkill", ["node"]

  defp node_result(pid) do
    receive do
      {^pid, :data, :out, log} ->
        IO.puts "Node log => #{log}"
        cond do
          String.contains? log, "running" ->
            HTTPoison.get! @root_url <> "/collection"
          true ->
            node_result(pid)
        end
    end
  end

  def collection do
    kill_node()
    System.put_env "NODE_ENV", "#{Mix.env}"
    cmd = "node node_app/src/index.js"
    opts = [out: {:send, self()}]
    %Porcelain.Process{pid: pid} = Porcelain.spawn_shell cmd, opts

    result = node_result(pid)

    {"", 0} = kill_node()

    with %HTTPoison.Response{body: body} <- result, do: body
  end
end
