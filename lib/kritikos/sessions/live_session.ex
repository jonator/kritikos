defmodule Kritikos.Sessions.LiveSession do
  @moduledoc """
  GenServer that represents a live session taking incoming feedback for a host
  """
  use GenServer
  alias Kritikos.{Sessions.ResolvedSession, Votes, Votes.Vote, Votes.Text}

  @enforce_keys [:keyword, :host_id]
  defstruct [:keyword, :host_id, :start_datetime, :votes, :texts]

  @type t() :: %__MODULE__{
          keyword: String.t(),
          host_id: integer(),
          start_datetime: DateTime.t(),
          votes: [Vote.t()] | [],
          texts: [Text.t()] | []
        }

  def start_link(%__MODULE__{keyword: k, host_id: host_id, start_datetime: _} = live_session) do
    {:via, Registry, reg} = via_registry(k)
    name = {:via, Registry, Tuple.append(reg, host_id)}
    GenServer.start_link(__MODULE__, live_session, name: name)
  end

  def exists?(keyword) do
    case Registry.lookup(Kritikos.SessionsRegistry, keyword) do
      [{_, _} | _] -> true
      [] -> false
    end
  end

  def submit_vote(%Vote{} = vote) do
    call_via_registry(vote.session_keyword, {:submit_vote, vote})
  end

  def submit_text(%Text{} = text) do
    cast_via_registry(text.session_keyword, {:submit_text, text})
  end

  @impl GenServer
  def init(%__MODULE__{host_id: _, keyword: _} = live_session) do
    init_session =
      live_session
      |> Map.put(:start_datetime, DateTime.utc_now())
      |> Map.put(:votes, [])
      |> Map.put(:texts, [])

    {:ok, init_session}
  end

  @impl GenServer
  def handle_call({:submit_vote, %Vote{} = vote}, _from, state) do
    voter_number = Enum.count(state.votes)
    vote = %{vote | voter_number: voter_number}
    {:reply, voter_number, %{state | votes: [vote | state.votes]}}
  end

  @impl GenServer
  def handle_cast({:submit_text, %Text{} = text}, state) do
    {:noreply, %{state | texts: [text | state.texts]}}
  end

  @impl GenServer
  def terminate(_reason, state) do
    session_id = ResolvedSession.create(state)
    Votes.ResolvedVote.create_all(session_id, state[:votes])
  end

  defp call_via_registry(keyword, request) do
    GenServer.call(via_registry(keyword), request)
  end

  defp cast_via_registry(keyword, request) do
    GenServer.cast(via_registry(keyword), request)
  end

  defp via_registry(keyword) do
    {:via, Registry, {Kritikos.SessionsRegistry, keyword}}
  end
end
