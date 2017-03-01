defmodule Exerself.PageControllerTest do
  use Exerself.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Exerself"
  end
end
