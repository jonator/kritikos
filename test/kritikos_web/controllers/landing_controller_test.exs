defmodule KritikosWeb.LandingControllerTest do
  use KritikosWeb.ConnCase, async: true

  test "get homepage", %{conn: conn} do
    conn = get(conn, "/")

    assert html_response(conn, 200) =~ "<title>Kritikos</title>"

    assert html_response(conn, 200) =~
             "<div id=\"name\">- John, university instructor</div>\n                </div>\n            </div>\n        </div>\n    </section>\n"
  end
end
