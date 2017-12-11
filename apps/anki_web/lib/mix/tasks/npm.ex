defmodule Mix.Tasks.Npm do
  use Mix.Task
  
  @shortdoc "Executes npm scripts from assets directory."
  @home __DIR__ <> "/../../.."

  def run(cmds) when is_list(cmds),
    do: cmds |> Enum.join(" ") |> run
  def run(cmds) when is_binary(cmds) do
    IO.puts "Running command: npm #{cmds}"
    "cd #{@home}/assets && npm #{cmds}"
    |> Mix.shell.cmd(stderr_to_stdout: true)
    |> case do
      0 -> :ok
      a -> raise "npm command failure exit code: #{a}"
    end
  end
end
