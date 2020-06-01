defmodule KritikosWeb.PortalControllerTest do
  use KritikosWeb.ConnCase, async: true

  test "open portal", %{conn: conn} do
    conn = get(conn, "/portal")

    assert html_response(conn, 200) =~
             "<h1 class=\"clickable\" onclick=\"window.location.href='/'\">Kritikos</h1>"

    assert html_response(conn, 200) =~
             "<script type=\"text/javascript\" src=\"/js/portal.js\"></script>"
  end
end
