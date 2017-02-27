defmodule Exerself.Repo.Migrations.CreateStationaryBikeRide do
  use Ecto.Migration

  def change do
    create table(:stationary_bike_rides) do
      add :started_at, :datetime
      add :duration, :integer
      add :power, :integer
      add :heart_rate, :integer
      add :notes, :text
      add :user, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:stationary_bike_rides, [:user])

  end
end
