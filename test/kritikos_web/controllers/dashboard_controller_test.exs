defmodule KritikosWeb.DashboardControllerTests do
  use KritikosWeb.ConnCase, async: true

  test "get dashboard Vue.js app", %{conn: conn} do
    conn =
      conn
      |> Helpers.put_user_auth_cookie()
      |> get("/dashboard")

    assert html_response(conn, 200) =~
             "<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\"/>\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"/>\n    <title>Kritikos</title>"
  end
end
