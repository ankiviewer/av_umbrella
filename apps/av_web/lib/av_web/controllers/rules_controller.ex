defmodule AvWeb.RulesController do
  use AvWeb, :controller

  alias Av.{Rule, Note}

  def index(conn, _params) do
    render conn, "index.html"
  end

  # TODO: make this channel instead
  def rules_sync(conn, %{"id" => id}) do
    notes = Note.all()
    notes
    |> Enum.map(fn note ->
      id
      |> Rule.rule(notes, note)
      |> Map.merge(%{nid: note.nid})
      |> Rule.insert!
    end)
    payload = %{}
    json conn, %{payload: payload, error: ""}
  end

  def rules(conn, %{"id" => id}) do
    all = id
    |> Rule.all
    |> List.filter(&(&1.fail))
    list = Rule.list()

    json conn, %{payload: %{all: all, list: list}, error: ""}
  end
end
