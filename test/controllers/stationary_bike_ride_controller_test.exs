defmodule Exerself.StationaryBikeRideControllerTest do
  use Exerself.ConnCase

  alias Exerself.StationaryBikeRide
  @valid_attrs %{duration: 42, heart_rate: 42, notes: "some content", power: 42, started_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, stationary_bike_ride_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, stationary_bike_ride_path(conn, :create), stationary_bike_ride: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(StationaryBikeRide, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, stationary_bike_ride_path(conn, :create), stationary_bike_ride: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    stationary_bike_ride = Repo.insert! %StationaryBikeRide{}
    conn = put conn, stationary_bike_ride_path(conn, :update, stationary_bike_ride), stationary_bike_ride: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(StationaryBikeRide, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    stationary_bike_ride = Repo.insert! %StationaryBikeRide{}
    conn = put conn, stationary_bike_ride_path(conn, :update, stationary_bike_ride), stationary_bike_ride: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    stationary_bike_ride = Repo.insert! %StationaryBikeRide{}
    conn = delete conn, stationary_bike_ride_path(conn, :delete, stationary_bike_ride)
    assert response(conn, 204)
    refute Repo.get(StationaryBikeRide, stationary_bike_ride.id)
  end
end
