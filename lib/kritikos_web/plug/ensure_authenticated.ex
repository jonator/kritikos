defmodule KritikosWeb.Plug.EnsureAuthenticated do
  @behaviour Plug
  @token_salt Application.get_env(:kritikos, KritikosWeb.Endpoint)[:secret_key_base]
  import Plug.Conn
  alias Kritikos.Auth

  def init([store: :cookie] = opts), do: opts
  def init([store: :token] = opts), do: opts

  def call(conn, store: store_type) do
    case store_type do
      :cookie ->
        case get_session(conn, :user) do
          nil ->
            redirect_to_portal(conn)

          user ->
            if user.is_active do
              assign(conn, :user, user)
            else
              redirect_to_portal(conn)
            end
        end

      :token ->
        case conn.params["token"] do
          nil ->
            invalid_token_resp(conn)

          token ->
            case Phoenix.Token.verify(KritikosWeb.Endpoint, @token_salt, token, max_age: 86_400) do
              {:ok, user_id} ->
                case Auth.get_user_if_active(user_id) do
                  {:ok, user} ->
                    assign(conn, :user, user)

                  {:error, reason} ->
                    invalid_token_resp(conn, Atom.to_string(reason))
                end

              {:error, reason} ->
                invalid_token_resp(conn, Atom.to_string(reason))
            end
        end
    end
  end

  defp redirect_to_portal(conn) do
    conn
    |> put_status(:unauthorized)
    |> Phoenix.Controller.redirect(to: "/portal")
    |> halt
  end

  defp invalid_token_resp(conn, err_reason_string \\ "") do
    msg = String.trim("invalid token " <> err_reason_string)

    conn
    |> put_status(:unauthorized)
    |> Phoenix.Controller.put_view(KritikosWeb.ErrorView)
    |> Phoenix.Controller.render("redirect.json", %{message: msg, redirect: "/portal"})
    |> halt
  end
end
