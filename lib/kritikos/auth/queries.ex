defmodule Kritikos.Auth.Queries do
  import Ecto.Query, warn: false
  alias Kritikos.Auth.User

  def active_user(user_id) do
    from u in User, where: u.id == ^user_id and u.is_active == true
  end

  def user_assocs(user_id, assocs) do
    Kritikos.Auth.get_user(user_id) |> Ecto.assoc(assocs)
  end
end
