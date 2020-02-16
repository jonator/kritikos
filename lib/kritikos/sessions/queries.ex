defmodule Kritikos.Sessions.Queries do
  import Ecto.Query, warn: false
  alias Kritikos.Auth
  alias Kritikos.Sessions.Session

  def open(keyword) do
    from s in all_open(),
      where: s.keyword == ^keyword
  end

  def for_user(user_id) do
    Ecto.assoc(Auth.get_user(user_id), :sessions)
  end

  def all_open do
    now = DateTime.utc_now()
    from s in Session, where: is_nil(s.end_datetime) or s.end_datetime < ^now
  end

  def all_open_for_user(user_id) do
    intersect(for_user(user_id), ^all_open())
  end
end
