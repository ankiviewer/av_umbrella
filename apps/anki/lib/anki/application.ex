defmodule Anki.Application do
  @moduledoc """
  The Anki Application Service.

  The anki system business domain lives in this application.

  Exposes API to clients such as the `AnkiWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      supervisor(Anki.Repo, []),
    ], strategy: :one_for_one, name: Anki.Supervisor)
  end
end
