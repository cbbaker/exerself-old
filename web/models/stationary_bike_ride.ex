defmodule Exerself.StationaryBikeRide do
  use Exerself.Web, :model

  schema "stationary_bike_rides" do
    field :started_at, Ecto.DateTime
    field :duration, :integer
    field :power, :integer
    field :heart_rate, :integer
    field :notes, :string
    belongs_to :user, Exerself.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:started_at, :duration, :power, :heart_rate, :notes])
    |> validate_required([:started_at, :duration, :power, :heart_rate, :notes])
  end
end
