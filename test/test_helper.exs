ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Kritikos.Repo, :manual)

defmodule Helpers do
  def put_user_auth_cookie(conn) do
    {:ok, user} =
      Kritikos.Auth.register_user(%{
        email: "mike@email.com",
        first_last_name: "mike a",
        password: "a",
        password_confirmation: "a"
      })

    conn
    |> Plug.Test.init_test_session(%{user: user})
  end
end
