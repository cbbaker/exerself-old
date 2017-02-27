defmodule Exerself.Auth do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    current_user = get_session(conn, :current_user)
    cond do
      # pass through current_user if it's already set
      #  otherwise this is hard to test--cbb 2016-08-06
      conn.assigns[:current_user] ->
        conn
      true ->
        assign(conn, :current_user, current_user)
    end
  end
end
