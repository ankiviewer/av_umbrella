defmodule Av.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Av.User
  alias Ecto.Changeset
  alias Comeonin.Bcrypt

  schema "users" do
    field :is_admin, :boolean, default: false
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @required_fields ~w(name)a
  @optional_fields ~w(is_admin)a
  def changeset(%User{} = user, attrs \\ %{}) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def registration_changeset(struct, params) do
    struct
    |> changeset(params)
    |> cast(params, ~w(password)a, [])
    |> validate_length(:password, min: 6, max: 100)
    |> hash_password
  end

  defp hash_password(changeset) do
    case changeset do
      %Changeset{valid?: true,
                      changes: %{password: password}} ->
        put_change(changeset,
                   :password_hash,
                   Bcrypt.hashpwsalt(password))
      _ ->
        changeset
    end
  end
end
