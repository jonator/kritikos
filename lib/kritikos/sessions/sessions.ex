defmodule Kritikos.Sessions do
  @moduledoc """
  Contains API for accessing sessions data.
  """
  require DateTime
  alias Kritikos.Repo
  alias __MODULE__.{Session, Queries}

  def start(profile_id, keyword, session_tags) do
    case Session.create_changeset(%Session{}, %{
           keyword: keyword,
           profile_id: profile_id,
           tags: session_tags
         })
         |> Repo.insert() do
      {:ok, _session} = valid ->
        valid

      {:error, _changeset} = err ->
        err
    end
  end

  def stop(keyword) do
    case get_open(keyword) do
      nil ->
        {:error, "session not open"}

      session ->
        now = DateTime.utc_now()

        %{session | end_datetime: now}
        |> Session.changeset()
        |> Repo.update()
    end
  end

  def get_open(keyword) do
    Queries.open(keyword)
    |> Repo.one()
  end

  def get_all_open do
    Queries.all_open()
    |> Repo.all()
  end

  def get_for_user_with_preloads(user_id, preloads) do
    Queries.for_user(user_id) |> Repo.all() |> Repo.preload(preloads)
  end
end
