defmodule KritikosWeb.LandingControllerTest do
  use KritikosWeb.ConnCase, async: true

  test "get homepage", %{conn: conn} do
    conn = get(conn, "/")

    assert html_response(conn, 200) =~ "<title>Kritikos</title>"

    assert html_response(conn, 200) =~
             "<li>patients</li>\n                <li>users</li>\n                <li>clients</li>\n                <li>attendees</li>\n                <li>audience members</li>"
  end

  test "open portal", %{conn: conn} do
    conn = get(conn, "/portal")

    assert html_response(conn, 200) =~
             "<h1 class=\"clickable\" onclick=\"window.location.href='/'\">Kritikos</h1>"

    assert html_response(conn, 200) =~
             "<script type=\"text/javascript\" src=\"/js/landing.js\"></script>"
  end
end
