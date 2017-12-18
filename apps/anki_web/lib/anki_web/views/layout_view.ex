defmodule AnkiWeb.LayoutView do
  use AnkiWeb, :view

  @views_map %{
    "/" => "Home",
    "/search" => "Search",
    "/rules" => "Rules",
    "/settings" => "Settings"
  }

  def views(%{request_path: request_path} = _conn) do
    @views_map
    |> Enum.to_list
    |> Enum.map(fn {link, text} -> {link, text, link == request_path} end)
  end

  def view_name(%{request_path: request_path} = _conn),
    do: @views_map[request_path]

end
