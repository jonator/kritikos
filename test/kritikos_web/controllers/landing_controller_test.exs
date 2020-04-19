defmodule KritikosWeb.LandingControllerTest do
  use KritikosWeb.ConnCase, async: true

  test "get homepage", %{conn: conn} do
    conn = get(conn, "/")

    assert html_response(conn, 200) =~ "<title>Kritikos</title>"

    assert html_response(conn, 200) =~
             "5.48731,25.46875l-2.84375,1.44238c-11.86328,6.00635-24.13086,12.21679-33.59863,21.58056a52.813,52.813,0,0,0-4.208,4.69971c11"
  end

  test "open portal", %{conn: conn} do
    conn = get(conn, "/portal")

    assert html_response(conn, 200) =~
             "<h1 class=\"clickable\" onclick=\"window.location.href='/'\">Kritikos</h1>"

    assert html_response(conn, 200) =~
             "<script type=\"text/javascript\" src=\"/js/landing.js\"></script>"
  end
end
