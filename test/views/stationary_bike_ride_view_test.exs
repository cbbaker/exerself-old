defmodule Exerself.StationaryBikeRideViewTest do
  use Exerself.ConnCase, async: true
  import Phoenix.View

  alias Exerself.StationaryBikeRideView

  @user %Exerself.User{id: 1}
  @ride %Exerself.StationaryBikeRide{id: 2, user_id: 1, started_at: "2017-01-02", duration: 60, power: 100, heart_rate: 120}

  test "renders the view" do
    result = render StationaryBikeRideView, "index.json", current_user: @user, stationary_bike_rides: [@ride]
    assert result
  end
  
  
end
