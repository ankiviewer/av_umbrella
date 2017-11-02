defmodule Anki.Node do
  use GenServer
  alias Porcelain.Process, as: Proc
  alias Porcelain.Result, as: Res

  def start_link do
    GenServer.start_link __MODULE__, %{}
  end

  def start_server() do
    IO.puts "Starting Node Server..."
    cmd = "node node_app/src/index.js"
    opts = [out: {:send, self()}]
    %Proc{pid: pid} = Porcelain.spawn_shell(cmd, opts)

    receive do
      {^pid, :data, :out, log} ->
        IO.puts "Node log => #{log}"
      {^pid, :result, %Res{status: _status}} ->
        IO.puts "restarting"
        stop_current_process()
        start_server()
    end
  end

  # Stops all node processes
  defp stop_current_process() do
    IO.puts "Stopping Node Server..."
    {output, 0} = System.cmd("lsof", ["-i"])
    node_pid =
      output
      |> String.split("\n")
      |> Enum.find(&Regex.match?(~r/^node/, &1))
      |> (&Regex.run(~r/^node\s+(\d+)/, &1)).()
      |> Enum.at(1)
    {"", 0} = System.cmd "kill", ["-9", node_pid]
    IO.puts "Node server stopped"
  end
end
