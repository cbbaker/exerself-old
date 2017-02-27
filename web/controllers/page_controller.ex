defmodule Exerself.PageController do
  use Exerself.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
