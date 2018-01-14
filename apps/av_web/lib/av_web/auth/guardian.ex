defmodule AvWeb.Auth.Guardian do
  use Guardian, otp_app: :av_web

  alias Av.{User, Repo}

  def subject_for_token(%User{} = user, _claims), do: {:ok, "User:#{user.id}"}
  def subject_for_token(_, _), do: {:error, :unknown_resource_type}

  def resource_from_claims(%{"sub" => sub}) do
    "User:" <> id = sub
    {:ok, Repo.get(User, id)}
  end
  def resource_from_claims(_), do: {:error, :unknown_resource_type}
end
