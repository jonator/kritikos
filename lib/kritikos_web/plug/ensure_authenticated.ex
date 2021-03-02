defmodule KritikosWeb.Plug.EnsureAuthenticated do
  @moduledoc """
  Plug pipeline that ensures a user's connection contains a valid cookie or token.
  """
  @behaviour Plug
  import Plug.Conn
  alias Kritikos.{Auth, Auth.User}

  def init([store: :cookie] = opts), do: opts
  def init([store: :token] = opts), do: opts

  def call(conn, store: store_type) do
    case store_type do
      :cookie ->
        verify_cookie(conn, get_session(conn, :user))

      :token ->
        verify_token(conn, conn.params["token"])
    end
  end

  defp verify_cookie(conn, nil), do: redirect_to_portal(conn)
  defp verify_cookie(conn, %User{is_active: true} = user), do: assign(conn, :user, user)
  defp verify_cookie(conn, %User{}), do: redirect_to_portal(conn)

  defp verify_token(conn, nil), do: invalid_token_resp(conn)

  defp verify_token(conn, token) do
    case Phoenix.Token.verify(KritikosWeb.Endpoint, token_salt(), token, max_age: 86_400) do
      {:ok, user_id} ->
        case Auth.get_active_user(user_id) do
          %User{} = user ->
            assign(conn, :user, user)

          nil ->
            invalid_token_resp(conn, "inactive user")
        end

      {:error, reason} ->
        invalid_token_resp(conn, Atom.to_string(reason))
    end
  end

  defp redirect_to_portal(conn) do
    conn
    |> Phoenix.Controller.redirect(to: "/portal?ref=#{conn.request_path}")
    |> halt
  end

  defp invalid_token_resp(conn, err_reason_string \\ "") do
    msg = String.trim("invalid token " <> err_reason_string)

    conn
    |> put_status(:unauthorized)
    |> Phoenix.Controller.put_view(KritikosWeb.ErrorView)
    |> Phoenix.Controller.render("error.json", %{message: msg})
    |> halt
  end

  defp token_salt, do: Application.get_env(:kritikos, KritikosWeb.Endpoint)[:secret_key_base]
end
