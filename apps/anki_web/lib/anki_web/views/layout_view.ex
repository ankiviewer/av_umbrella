defmodule AnkiWeb.LayoutView do
  use AnkiWeb, :view

  @views_map %{
    "/" => "Home",
    "/search" => "Search",
    "/rules" => "Rules",
    "/settings" => "Settings"
  }

  def views, do: @views_map

  def view_name(%{request_path: request_path} = _conn),
    do: @views_map[request_path]

end
