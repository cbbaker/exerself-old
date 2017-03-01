defmodule Exerself.StationaryBikeRideView do
  use Exerself.Web, :view

  def render("index.json", %{stationary_bike_rides: stationary_bike_rides, current_user: %{id: user_id}}) do
    # %{data: render_many(stationary_bike_rides, Exerself.StationaryBikeRideView, "stationary_bike_ride.json")}
    defaults = case stationary_bike_rides do
                 [last_ride | _] -> last_ride
                 _ -> %{user_id: user_id}
               end

    container(%{}, %{
      panel: panel(%{}, %{
        heading: %{
          type: "Title",
          text: "Listing rides",
          level: 3,
          classes: ["panel-title"]
        },
        body: container(%{}, %{
          flash: row(%{}, flash()),
          newButton: row(%{}, %{
            pullRight: pull_right(%{}, %{
              createButton: new_ride_button(defaults)
            })
          }),
          list: row(%{}, %{
            list: ride_list_group(stationary_bike_rides)
          })
        })
      })
    })
  end

  def render("show.json", %{stationary_bike_ride: stationary_bike_ride}) do
    %{data: render_one(stationary_bike_ride, Exerself.StationaryBikeRideView, "stationary_bike_ride.json")}
  end

  def render("stationary_bike_ride.json", %{stationary_bike_ride: stationary_bike_ride}) do
    %{id: stationary_bike_ride.id,
      user_id: stationary_bike_ride.user_id,
      started_at: stationary_bike_ride.started_at,
      duration: stationary_bike_ride.duration,
      power: stationary_bike_ride.power,
      heart_rate: stationary_bike_ride.heart_rate,
      notes: stationary_bike_ride.notes}
  end

  def layout(type, subscriptions, children) do
    %{type: type,
      children: children,
      subscriptions: subscriptions
    }
  end

  def container(subscriptions, children), do: layout("Container", subscriptions, children)
  def panel(subscriptions, children), do: layout("Panel", subscriptions, children)
  def row(subscriptions, children), do: layout("Row", subscriptions, children)
  def list_group(subscriptions, children), do: layout("ListGroup", subscriptions, children)
  def pull_right(subscriptions, children), do: layout("PullRight", subscriptions, children)

  def choice(subscriptions, children, initial) do
    %{type: "Choice",
      subscriptions: subscriptions,
      children: children,
      initial: initial
    }
  end

  def ride_list_group(rides) do
    children = for ride <- rides, into: %{} do
      id = "item" <> to_string(ride.id)
      {id,
       choice(id, %{
         show: ride_show(ride, id),
         edit: ride_edit(ride, id)
       }, "show")
      }
    end

    list_group %{insert: "insertRide", delete: "deleteRide"}, children
  end

  def flash(), do: %{type: "Flash"}

  def new_ride_button(last_ride) do
    %{type: "NewRideButton",
      text: "Create new",
      enabled: true,
      actions: %{
        press: %{
          links: [],
          publishes: [
            %{channel: "newRideButton", 
              payload: %{enabled: false}
            },
            %{channel: "insertRide",
              payload: %{
                newItem: new_ride(last_ride)
              }
            }
          ]
        }
      }
    }
  end

  def new_ride(defaults) do
    choice "newItem", %{
      show: ride_show(defaults, "newItem"),
      edit: ride_edit(defaults, "newItem")
    }, "edit"
  end

  def ride_show(defaults, prefix) do
    %{type: "RideShow",
      subscription: prefix <> "Edit",
      data: defaults,
      actions: %{
        edit: %{
          links: [],
          publishes: [
            %{channel: prefix, payload: "edit"},
            %{channel: prefix <> "Show"}
          ]
        }
      }
    }
  end

  def ride_edit(defaults, prefix) do
    %{type: "RideEdit",
      subscription: prefix <> "Show",
      data: defaults,
      actions: %{
        cancel: %{
          links: [],
          publishes: [
            %{channel: "deleteRide", payload: [prefix]}
          ]
        },
        update: %{
          links: [
            %{url: stationary_bike_ride_path(Exerself.Endpoint, :create),
              method: "POST",
              success: prefix <> "Update"
             }
          ],
          publishes: [
            %{channel: prefix <> "Edit"},
            %{channel: prefix, payload: "show"}
          ]
        }
      }
    }
  end

end
