defmodule Anki.Node do
  alias Porcelain.Process, as: Proc
  alias Porcelain.Result, as: Res

  def start_server() do
    System.put_env "NODE_ENV", "#{Mix.env}"
    IO.puts "Starting Node Server..."
    cmd = "node node_app/src/index.js"
    opts = [out: {:send, self()}]
    proc = %Proc{pid: pid} = Porcelain.spawn_shell(cmd, opts)

    receive do
      {^pid, :data, :out, log} ->
        IO.puts "Node log => #{log}"
      {^pid, :result, %Res{status: _status} = res} ->
        IO.puts "-------"
        IO.inspect res
        # IO.puts "stopping proc"
        # stop_all_node_processes()
        # start_server()
    end
    Proc.await(proc, 1000)
  end

  def stop_all_node_processes() do
    IO.puts "Stopping Node Server..."
    {_output, _code} = System.cmd "pkill", ["node"]
    IO.puts "Node server stopped"
  end
end
