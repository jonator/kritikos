defmodule Kritikos.Sessions.Queries do
  import Ecto.Query, warn: false
  alias Kritikos.Auth

  def open(keyword) do
    now = DateTime.utc_now()

    from s in Session,
      where: s.keyword == ^keyword and (is_nil(s.end_datetime) or s.end_datetime < ^now)
  end

  def for_user(user_id) do
    Auth.Queries.user_assocs(user_id, [:profile, :sessions])
  end
end
