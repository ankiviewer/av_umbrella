defmodule AnkiWeb.HomeController do
  use AnkiWeb, :controller

  alias Anki.{Repo, Collection}

  @months ~w(jan feb mar apr may jun jul aug sep oct nov dec)

  def index(conn, _params) do
    naive = Collection |> Repo.one |> Map.fetch!(:updated_at)

    %{day: day, hour: hour, minute: minute, month: month, year: year} = naive
    month = @months |> Enum.at(month - 1) |> String.capitalize
    year = year - 2000

    updated_at = "#{day} #{month} #{year} at #{hour}:#{minute}"
    
    render conn, "index.html", updated_at: updated_at
  end
end
