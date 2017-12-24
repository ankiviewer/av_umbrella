defmodule AnkiWeb.DeckController do
  use AnkiWeb, :controller

  alias Anki.{Collection, Repo}

  @months ~w(jan feb mar apr may jun jul aug sept oct nov dec)

  def index(conn, _params) do
    naive = Collection |> Repo.one |> Map.fetch!(:updated_at)

    %{day: day, hour: hour, minute: minute, month: month, year: year} = naive
    month = @months |> Enum.at(month - 1) |> String.capitalize
    year = year - 2000

    payload = "#{day} #{month} #{year} at #{hour}:#{minute}"

    json conn, %{payload: payload}
  end
end
