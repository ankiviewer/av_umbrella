defmodule AnkiWeb.SynchronizeController do
  use AnkiWeb, :controller

  @types ~w(collection notes)

  def create(conn, %{"type" => type}) when type in @types do
    IO.puts "Synchronizing #{type}"
    
    "/#{type}"
    |> Anki.request!

    json conn, %{"message" => "success"}
  end

  def create(_conn, %{"type" => type}),
    do: raise ArgumentError, message: ~s(Expected type to be one of ["#{@types |> Enum.join("\", \"")}"]. Was given %{"type" => "#{type}"})
end
