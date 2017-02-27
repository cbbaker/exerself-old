defmodule Exerself.StationaryBikeRideController do
  use Exerself.Web, :controller

  alias Exerself.StationaryBikeRide

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
          [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, nil) do
    not_authorized(conn, "You must be logged in to see rides")
  end


  def index(conn, _params, user) do
    stationary_bike_rides = Repo.all(StationaryBikeRide)
    render(conn, "index.json", stationary_bike_rides: stationary_bike_rides)
  end

  def create(conn, %{"stationary_bike_ride" => stationary_bike_ride_params}, user) do
    changeset = StationaryBikeRide.changeset(%StationaryBikeRide{}, stationary_bike_ride_params)

    case Repo.insert(changeset) do
      {:ok, stationary_bike_ride} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", stationary_bike_ride_path(conn, :show, stationary_bike_ride))
        |> render("show.json", stationary_bike_ride: stationary_bike_ride)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Exerself.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "stationary_bike_ride" => stationary_bike_ride_params}, user) do
    stationary_bike_ride = Repo.get!(StationaryBikeRide, id)
    changeset = StationaryBikeRide.changeset(stationary_bike_ride, stationary_bike_ride_params)

    case Repo.update(changeset) do
      {:ok, stationary_bike_ride} ->
        render(conn, "show.json", stationary_bike_ride: stationary_bike_ride)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Exerself.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, user) do
    stationary_bike_ride = Repo.get!(StationaryBikeRide, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(stationary_bike_ride)

    send_resp(conn, :no_content, "")
  end

  defp not_authorized(conn, message) do
    conn
    |> put_status(:forbidden)
    |> json(%{message: message})
  end
end
