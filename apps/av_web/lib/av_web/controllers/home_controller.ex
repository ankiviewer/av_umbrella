defmodule AvWeb.HomeController do
  use AvWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end