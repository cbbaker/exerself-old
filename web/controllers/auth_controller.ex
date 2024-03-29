defmodule Exerself.AuthController do
  use Exerself.Web, :controller

  plug Ueberauth

  alias Ueberauth.Strategy.Helpers

  # def request(conn, _params) do
  #   render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  # end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    # |> redirect(to: root_path(conn, :app))
    |> redirect(to: "/")
  end

  def callback(%{ assigns: %{ ueberauth_failure: _fails } } = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    # |> redirect(to: root_path(conn, :app))
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case UserFromAuth.find_or_create(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:current_user, user)
        # |> redirect(to: challenge_path(conn, :app))
        |> redirect(to: "/")
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        # |> redirect(to: challenge_path(conn, :app))
        |> redirect(to: "/")
    end
  end
end
