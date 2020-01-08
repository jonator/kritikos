defmodule Kritikos.Sessions do
  @moduledoc """
  Contains API for accessing sessions data.
  """
  require DateTime
  alias Kritikos.Repo
  alias Kritikos.{Auth, Auth.Profile}
  alias __MODULE__.{Session, Tag, Queries}

  def start(host_id, session_tags) do
    profile_id = Profile.get_or_create_for_user(host_id) |> Map.take([:id])
    session = Session.changeset(%Session{}, %{profile_id: profile_id}) |> Repo.insert()
    tags = create_tags_for_session(session_tags, session.id)

    Map.merge(session, %{tags: tags})
  end

  def get_open(keyword) do
    Queries.open(keyword)
    |> Repo.one()
  end

  def create_tags_for_session(tags, session_id) do
    created_tags = Enum.map(tags, &Tag.changeset(%Tag{session_id: session_id}, &1))
    Repo.insert_all(Tag, created_tags, returning: true)
  end

  def get_for_user(user_id) do
    Queries.for_user(user_id) |> Repo.all()
  end
end
