defmodule Av.UserTest do
  use Av.DataCase, async: false

  describe "users" do
    alias Av.User
    alias Comeonin.Bcrypt
    alias Ecto.ConstraintError

    @valid_attrs %{name: "sam", password: "password"}
    @update_attrs %{name: "sam2", password: "password"}
    @invalid_attrs %{password: "password"}

    test "registration_changeset" do
      changeset = %User{} |> User.registration_changeset(@valid_attrs)

      assert changeset.valid?
      assert changeset.changes.name == @valid_attrs.name
      assert changeset.changes.password == @valid_attrs.password
      assert Bcrypt.checkpw(@valid_attrs.password, changeset.changes.password_hash)
    end

    test "non unique name" do
      insert_user @valid_attrs

      changeset = %User{} |> User.registration_changeset(@valid_attrs)

      assert changeset.valid?
      assert_raise ConstraintError, fn ->
        Repo.insert!(changeset)
      end
    end

    test "new user" do
      insert_user @valid_attrs

      changeset = %User{} |> User.registration_changeset(@update_attrs)

      assert changeset.valid?
      assert changeset.changes.name == @update_attrs.name
    end

    test "invalid_attrs" do
      changeset = %User{} |> User.registration_changeset(@invalid_attrs)

      refute changeset.valid?
    end
  end
end
