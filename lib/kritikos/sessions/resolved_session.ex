defmodule Kritikos.Sessions.ResolvedSession do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kritikos.Sessions.LiveSession

  schema "resolved_sessions" do
    field :end_datetime, :utc_datetime
    field :keyword, :string
    field :start_datetime, :utc_datetime
    field :host_id, :id
  end

  @doc false
  def changeset(resolved_session, attrs) do
    resolved_session
    |> cast(attrs, [:keyword, :start_datetime, :end_datetime, :host_id])
    |> validate_required([:keyword, :start_datetime, :end_datetime, :host_id])
    |> foreign_key_constraint(:host_id)
  end

  def create(%LiveSession{} = live_session) do
    resolved_session_attrs =
      Map.from_struct(live_session)
      |> Map.put(:end_datetime, DateTime.utc_now())

    changeset(%__MODULE__{}, resolved_session_attrs)
    |> Kritikos.Repo.insert!(returning: true)
    |> Map.get(:id)
  end
end
