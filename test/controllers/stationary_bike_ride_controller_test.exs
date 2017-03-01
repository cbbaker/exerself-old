defmodule Exerself.StationaryBikeRideControllerTest do
  use Exerself.ConnCase

  alias Exerself.StationaryBikeRide
  alias Exerself.User
  alias Exerself.Repo

  @valid_attrs %{duration: 42, heart_rate: 42, notes: "some content", power: 42, started_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "when not logged in" do
    test "index", %{conn: conn} do
      conn = get conn, stationary_bike_ride_path(conn, :index)
      assert json_response(conn, 403)
    end
  end

  describe "when logged in" do
    defp create_user(user_attribs) do
      %User{} |> User.changeset(user_attribs) |> Repo.insert!
    end

    setup %{conn: conn} do
      user = create_user(%{name: "Bob", avatar: "http://test.png", provider: "friendster", uid: "asdf"})
      conn = assign(conn, :current_user, user)
      [user: user, conn: conn]
    end

    test "lists all entries on index", %{conn: conn} do
      conn = get conn, stationary_bike_ride_path(conn, :index)
      assert json_response(conn, 200)["type"] == "Container"
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

    test "updates and renders chosen resource when data is valid", %{conn: conn, user: %{id: user_id}} do
      stationary_bike_ride = Repo.insert! %StationaryBikeRide{user_id: user_id}
      conn = put conn, stationary_bike_ride_path(conn, :update, stationary_bike_ride), stationary_bike_ride: @valid_attrs
      assert json_response(conn, 200)["data"]["id"]
      assert Repo.get_by(StationaryBikeRide, @valid_attrs)
    end

    test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: %{id: user_id}} do
      stationary_bike_ride = Repo.insert! %StationaryBikeRide{user_id: user_id}
      conn = put conn, stationary_bike_ride_path(conn, :update, stationary_bike_ride), stationary_bike_ride: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "deletes chosen resource", %{conn: conn, user: %{id: user_id}} do
      stationary_bike_ride = Repo.insert! %StationaryBikeRide{user_id: user_id}
      conn = delete conn, stationary_bike_ride_path(conn, :delete, stationary_bike_ride)
      assert response(conn, 204)
      refute Repo.get(StationaryBikeRide, stationary_bike_ride.id)
    end
  end
end
