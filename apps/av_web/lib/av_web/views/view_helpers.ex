defmodule AvWeb.ViewHelpers do
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

  def js_file(%{request_path: "/"}),
    do: "home.js"
  def js_file(%{request_path: "/" <> file}),
    do: file <> ".js"
end
