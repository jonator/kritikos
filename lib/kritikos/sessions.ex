defmodule Kritikos.Sessions do
  import Ecto.Query, warn: false
  alias Kritikos.Repo

  alias Kritikos.Sessions.ResolvedSession

  def list_resolved_sessions do
    Repo.all(ResolvedSession)
  end

  def get_resolved_session!(id), do: Repo.get!(ResolvedSession, id)

  def delete_resolved_session(%ResolvedSession{} = resolved_session) do
    Repo.delete(resolved_session)
  end

  def change_resolved_session(%ResolvedSession{} = resolved_session) do
    ResolvedSession.changeset(resolved_session, %{})
  end
end
