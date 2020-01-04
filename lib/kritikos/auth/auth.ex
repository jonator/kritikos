defmodule Kritikos.Auth do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false
  alias Kritikos.Repo
  alias Kritikos.Auth.{User, Profile}

  def get_user(id), do: Repo.get(User, id)

  def query_active_user(id) do
    from u in User, where: u.id == ^id and u.is_active == true
  end

  def query_user_record(id) do
    from u in query_active_user(id),
      inner_join: p in Profile,
      on: p.user_id == u.id,
      select: %{email: u.email, permanent_session: p.substitute_session_keyword}
  end

  def get_user_record(id) do
    query_user_record(id)
    |> Repo.one()
  end

  def query_user_assocs(user_id, assocs) do
    get_user(user_id) |> Ecto.assoc(assocs)
  end

  def get_user_assocs(user_id, assocs) do
    query_user_assocs(user_id, assocs)
    |> Repo.all()
  end

  def authenticate_user(email, plain_text_password) do
    if String.length(email) == 0 || String.length(plain_text_password) == 0 do
      {:error, %{credentials: ["invalid"]}}
    else
      case check_password(email, plain_text_password) do
        {:ok, _user} = valid_result ->
          valid_result

        _ ->
          {:error, %{credentials: ["invalid"]}}
      end
    end
  end

  def register_user(attrs \\ %{}) do
    case %User{} |> User.create_changeset(attrs) |> Repo.insert() do
      {:ok, user} = valid_result ->
        Ecto.build_assoc(user, :profile)
        |> Profile.changeset(attrs)
        |> Repo.insert!()

        valid_result

      {:error, _changeset} = error_result ->
        error_result
    end
  end

  defp check_password(email, plain_text_password) do
    Repo.get_by(User, email: email)
    |> Bcrypt.check_pass(plain_text_password)
  end
end
