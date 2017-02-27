defmodule Exerself.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :provider, :string
      add :uid, :string
      add :avatar, :string

      timestamps()
    end

  end
end
