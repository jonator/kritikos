defmodule Kritikos.Sessions do
  @moduledoc """
  Contains API for accessing sessions data.
  """
  require DateTime
  alias Kritikos.Repo
  alias __MODULE__.{Session, Queries}

  def start(profile_id, name, keyword, session_tags) do
    case Session.create_changeset(%Session{}, %{
           name: name,
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

        session
        |> Session.changeset(%{end_datetime: now})
        |> Repo.update()
    end
  end

  def export_qr_code(keyword) do
    port_string =
      Integer.to_string(Application.get_env(:kritikos, KritikosWeb.Endpoint)[:http][:port])

    host = Application.get_env(:kritikos, KritikosWeb.Endpoint)[:url][:host]
    Kritikos.Exporter.qr_code_png_binary(host <> ":" <> port_string <> keyword)
  end

  def get_open(keyword, opts \\ [])

  def get_open(keyword, []),
    do:
      Queries.open(keyword)
      |> Repo.one()

  def get_open(keyword, preload: keys), do: get_open(keyword) |> Repo.preload(keys)

  def get_all_open do
    Queries.all_open()
    |> Repo.all()
  end

  def get_all_open_for_user(user_id) do
    Queries.all_open_for_user(user_id)
    |> Repo.all()
  end

  def get_for_user(user_id, opts \\ [])

  def get_for_user(user_id, []) do
    Queries.for_user(user_id) |> Repo.all()
  end

  def get_for_user(user_id, preload: keys), do: get_for_user(user_id) |> Repo.preload(keys)
end
