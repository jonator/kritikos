defmodule Kritikos.Auth.Queries do
  @moduledoc """
  Defines database queries associated with user authentication.
  """
  import Ecto.Query, warn: false
  alias Kritikos.Auth.User

  def active_user(user_id) do
    from u in User, where: u.id == ^user_id and u.is_active == true
  end
end
