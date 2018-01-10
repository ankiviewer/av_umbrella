defmodule AvWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :av_web,
    error_handler: AvWeb.Auth.ErrorHandler,
    module: AvWeb.Auth.Guardian

	plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
end

