defmodule Av.Repo.Migrations.CreateRules do
  use Ecto.Migration

  def change do
    create table(:rules) do
      add :nid, :integer
      add :rid, :integer
      add :fail, :boolean, default: false, null: false
      add :comment, :text
      add :url, :string

      timestamps()
    end

  end
end
