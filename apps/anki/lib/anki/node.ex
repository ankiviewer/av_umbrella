defmodule Anki.Node do
  use GenServer
  alias Porcelain.Process, as: Proc
  alias Porcelain.Result, as: Res

  def start_link do
    GenServer.start_link __MODULE__, %{}
  end

  def init(state) do
    start_node_server()
    {:ok, state}
  end

  def start_node_server() do
    cmd = "node node_app/server/index.js"
    opts = [out: {:send, self()}]
    %Proc{pid: pid} = Porcelain.spawn_shell(cmd, opts)

    receive do
      {^pid, :data, :out, log} ->
        IO.puts "Node log => #{log}"
      {^pid, :result, %Res{status: _status}} ->
        IO.puts "restarting"
        stop_current_node_process()
        start_node_server()
    end
  end

  defp stop_current_node_process() do
    {output, 0} = System.cmd("lsof", ["-i"])
    node_pid =
      output
      |> String.split("\n")
      |> Enum.find(&Regex.match?(~r/^node/, &1))
      |> (&Regex.run(~r/^node\s+(\d+)/, &1)).()
      |> Enum.at(1)
    System.cmd "kill", ["-9", node_pid]
  end
end
