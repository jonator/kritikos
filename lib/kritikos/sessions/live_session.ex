defmodule Kritikos.Sessions.LiveSession do
  @moduledoc """
  GenServer that represents a live session taking incoming feedback for a host
  """
  use GenServer
  alias Kritikos.{Sessions.ResolvedSession, Votes, Votes.Vote}

  @enforce_keys [:keyword, :host_id]
  defstruct [:keyword, :host_id, :start_datetime, :votes]

  @type t() :: %__MODULE__{
          keyword: String.t(),
          host_id: integer(),
          start_datetime: DateTime.t(),
          votes: [Votes.Vote.t()] | []
        }

  def start_link(%__MODULE__{keyword: k, host_id: hid} = live_session) do
    {:via, Registry, reg} = via_registry(k)
    name = {:via, Registry, Tuple.append(reg, hid)}
    GenServer.start_link(__MODULE__, live_session, name: name)
  end

  def exists?(keyword) do
    case Registry.lookup(Kritikos.SessionsRegistry, keyword) do
      [{_, _} | _] -> true
      [] -> false
    end
  end

  def submit_vote(keyword, %Vote{} = vote) do
    cast_via_registry(keyword, {:submit_vote, vote})
  end

  @impl GenServer
  def init(%__MODULE__{host_id: _, keyword: _} = live_session) do
    init_session =
      live_session
      |> Map.put(:start_datetime, DateTime.utc_now())
      |> Map.put(:votes, [])

    {:ok, init_session}
  end

  @impl GenServer
  def handle_cast({:submit_vote, %Vote{} = vote}, state) do
    {:noreply, Map.update!(state, :votes, &[vote | &1])}
  end

  @impl GenServer
  def terminate(_reason, state) do
    session_id = ResolvedSession.create(state)
    Votes.ResolvedVote.create_all(session_id, state[:votes])
  end

  defp cast_via_registry(keyword, request) do
    GenServer.cast(via_registry(keyword), request)
  end

  defp via_registry(keyword) do
    {:via, Registry, {Kritikos.SessionsRegistry, keyword}}
  end
end
