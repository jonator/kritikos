defmodule Kritikos.Auth.Queries do
  import Ecto.Query, warn: false
  alias Kritikos.Auth.{User, Profile}

  def active_user(user_id) do
    from u in User, where: u.id == ^user_id and u.is_active == true
  end

  def user_record(user_id) do
    from u in active_user(user_id),
      inner_join: p in Profile,
      on: p.user_id == u.id,
      select: %{
        id: u.id,
        email: u.email,
        name: p.name,
        permanent_session: p.substitute_session_keyword
      }
  end

  def user_assocs(user_id, assocs) do
    Kritikos.Auth.get_user(user_id) |> Ecto.assoc(assocs)
  end
end
