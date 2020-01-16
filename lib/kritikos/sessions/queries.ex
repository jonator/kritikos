defmodule Kritikos.Sessions.Queries do
  import Ecto.Query, warn: false
  alias Kritikos.Auth
  alias Kritikos.Sessions.Session

  def open(keyword) do
    from s in all_open(),
      where: s.keyword == ^keyword
  end

  def for_user(user_id) do
    Auth.Queries.user_assocs(user_id, [:profile, :sessions])
  end

  def all_open do
    now = DateTime.utc_now()
    from s in Session, where: is_nil(s.end_datetime) or s.end_datetime < ^now
  end
end
