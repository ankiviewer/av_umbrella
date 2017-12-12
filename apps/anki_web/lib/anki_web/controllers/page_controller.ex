defmodule AnkiWeb.PageController do
  use AnkiWeb, :controller

  alias AnkiWeb.LayoutView

  def styleguide(conn, _params) do
    render conn, "styleguide.html",
      layout: {LayoutView, "plain.html"}
  end
end
