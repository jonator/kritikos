defmodule KritikosWeb.Plug.EnsureAuthenticated do
  @behaviour Plug
  import Plug.Conn
  alias Kritikos.{Auth, Auth.User}

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
