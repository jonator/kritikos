defmodule Kritikos.Sessions.Queries do
  @moduledoc """
  Composes Kritikos voting session database queries.
  """
  import Ecto.Query, warn: false
  alias Kritikos.Auth
  alias Kritikos.Sessions.Session

  def active do
    from s in Session, where: s.is_active
  end

  def open(keyword) do
    from s in all_open(),
      where: s.keyword == ^keyword
  end

  def for_user(user_id) do
    intersect(Ecto.assoc(Auth.get_user(user_id), :sessions), ^active())
  end

  def all_open do
    now = DateTime.utc_now()
    from s in active(), where: is_nil(s.end_datetime) or s.end_datetime > ^now
  end

  def all_open_for_user(user_id) do
    intersect(for_user(user_id), ^all_open())
  end
end
