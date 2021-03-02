defmodule KritikosWeb.Plug.AdminOnly do
  @moduledoc """
  Plug redirects non admin user connections.
  """
  @behaviour Plug
  import Plug.Conn
  alias Kritikos.Auth.User

  def init(opts), do: opts

  def call(conn, _) do
    admin_email = Application.fetch_env!(:kritikos, :admin_email)

    %User{email: email} =
      KritikosWeb.Plug.EnsureAuthenticated.call(conn, store: :cookie).assigns.user

    if email == admin_email do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> Phoenix.Controller.redirect(to: "/portal?ref=#{conn.request_path}")
      |> halt
    end
  end
end
