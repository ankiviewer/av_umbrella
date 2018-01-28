defmodule AvWeb.RulesController do
  use AvWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  # TODO: make this channel instead
  def rules_sync(conn, %{"id" => id}) do
    conn
  end

  def rules(conn, %{"id" => id}) do
    json conn %{payload: payload, error: ""}
  end

  def rules(conn, _params) do
    payload = %{}
    json conn %{payload: payload, error: ""}
  end
end
