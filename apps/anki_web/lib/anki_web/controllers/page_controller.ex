defmodule AnkiWeb.PageController do
  use AnkiWeb, :controller

  alias AnkiWeb.LayoutView

  def index(conn, _params) do
    render conn, "index.html"
  end

  def show(conn, %{"id" => "styleguide"}) do
    render conn, "styleguide.html",
      layout: {LayoutView, "plain.html"}
  end
end
