defmodule Kritikos.Sessions do
  @moduledoc """
  Contains API for accessing sessions data.
  """
  require DateTime
  require Logger
  alias Kritikos.Repo
  alias __MODULE__.{Session, Queries}

  def start(attrs) do
    case Session.create_changeset(%Session{}, attrs)
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

        case session
             |> Session.changeset(%{end_datetime: now})
             |> Repo.update() do
          {:ok, updated_session} ->
            {:ok, updated_session |> Repo.preload([{:votes, :feedback}])}

          {:error, _changeset} = err ->
            err
        end
    end
  end

  def delete(session_id) when is_integer(session_id) do
    case Repo.get(Queries.active(), session_id) do
      nil ->
        {:error, "not found"}

      session ->
        case Session.changeset(session, %{is_active: false})
             |> Repo.update() do
          {:ok, updated_session} ->
            {:ok, updated_session}

          {:error, _changeset} = err ->
            err
        end
    end
  end

  def delete(session_id) do
    case Integer.parse(session_id) do
      {int, _} ->
        delete(int)

      :error ->
        {:error, "bad request"}
    end
  end

  def export_qr_code(keyword) do
    host = Application.fetch_env!(:kritikos, KritikosWeb.Endpoint)[:url][:host]
    export_string = "https://" <> host <> "/" <> keyword

    Logger.info("Exporting QR Code: #{export_string}")
    Kritikos.Exporter.qr_code_png_binary(export_string)
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
  def get_for_user(user_id, []), do: Queries.for_user(user_id) |> Repo.all()
  def get_for_user(user_id, preload: keys), do: get_for_user(user_id) |> Repo.preload(keys)
end
