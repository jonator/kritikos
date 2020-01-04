defmodule Kritikos.Sessions do
  @moduledoc """
  Contains API for accessing sessions data.
  """
  import Ecto.Query, warn: false
  require DateTime
  alias Kritikos.Repo
  alias Kritikos.{Auth, Auth.Profile}
  alias Kritikos.Sessions.{Session, Tag}

  def start(host_id, session_tags) do
    profile_id = Profile.get_or_create_for_user(host_id) |> Map.take([:id])
    session = Session.changeset(%Session{}, %{profile_id: profile_id}) |> Repo.insert()
    tags = create_tags_for_session(session_tags, session.id)

    Map.merge(session, %{tags: tags})
  end

  def query_get_open(keyword) do
    now = DateTime.utc_now()

    from s in Session,
      where: s.keyword == ^keyword and (is_nil(s.end_datetime) or s.end_datetime < ^now)
  end

  def get_open(keyword) do
    query_get_open(keyword)
    |> Repo.one()
  end

  def create_tags_for_session(tags, session_id) do
    created_tags = Enum.map(tags, &Tag.changeset(%Tag{session_id: session_id}, &1))
    Repo.insert_all(Tag, created_tags, returning: true)
  end

  def query_user_sessions(user_id) do
    Auth.query_user_assocs(user_id, [:profile, :sessions])
  end

  def get_user_sessions(user_id) do
    query_user_sessions(user_id) |> Repo.all()
  end
end
