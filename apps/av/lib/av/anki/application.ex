defmodule Av.Application do
  @moduledoc """
  The Av Application Service.

  The av system business domain lives in this application.

  Exposes API to clients such as the `AvWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      supervisor(Av.Repo, []),
    ], strategy: :one_for_one, name: Av.Supervisor)
  end
end
