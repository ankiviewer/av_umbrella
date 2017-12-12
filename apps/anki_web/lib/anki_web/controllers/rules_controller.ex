defmodule AnkiWeb.RulesController do
  use AnkiWeb, :controller

  alias AnkiWeb.LayoutView

  def index(conn, _params) do
    render conn, "index.html"
  end
end
