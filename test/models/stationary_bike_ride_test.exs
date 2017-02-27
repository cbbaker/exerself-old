defmodule Exerself.StationaryBikeRideTest do
  use Exerself.ModelCase

  alias Exerself.StationaryBikeRide

  @valid_attrs %{duration: 42, heart_rate: 42, notes: "some content", power: 42, started_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = StationaryBikeRide.changeset(%StationaryBikeRide{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = StationaryBikeRide.changeset(%StationaryBikeRide{}, @invalid_attrs)
    refute changeset.valid?
  end
end
