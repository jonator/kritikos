defmodule Kritikos.Sessions.LiveSession do
  @moduledoc """
  GenServer that represents a live session taking incoming feedback for a host
  """
  use GenServer
  alias Kritikos.{Auth, Auth.User, Sessions.ResolvedSession, Votes, Votes.Vote, Votes.Text}
  require Logger

  @enforce_keys [:keyword, :host_id]
  defstruct [:keyword, :host_id, :start_datetime, :votes, :texts, :exporter_sup]

  @type t() :: %__MODULE__{
          keyword: String.t(),
          host_id: integer(),
          start_datetime: DateTime.t(),
          votes: [Vote.t()] | [],
          texts: [Text.t()] | [],
          exporter_sup: pid()
        }

  @registry Kritikos.SessionsRegistry

  def start_link(%__MODULE__{keyword: k, host_id: host_id, start_datetime: _} = live_session) do
    {:via, Registry, reg} = via_registry(k)
    name = {:via, Registry, Tuple.append(reg, host_id)}
    GenServer.start_link(__MODULE__, live_session, name: name)
  end

  def exists?(id) when is_bitstring(id) do
    case Registry.lookup(@registry, id) do
      [{_, _} | _] -> true
      [] -> false
    end
  end

  def exists?(id) when is_pid(id) do
    case Registry.select(@registry, [{{:"$1", :"$2", :"$3"}, [{:==, :"$2", id}], [:"$2"]}]) do
      [pid] when is_pid(pid) ->
        true

      _ ->
        false
    end
  end

  def take_state(id, keys) when is_bitstring(id) do
    case Registry.lookup(@registry, id) do
      [{pid, _user_id} | _] ->
        GenServer.call(pid, {:take_state, keys})

      [] ->
        :not_found
    end
  end

  def take_state(id, keys) when is_number(id) do
    with [{_keyword, pid} | _] <-
           Registry.select(@registry, [
             {{:"$1", :"$2", :"$3"}, [{:==, :"$3", id}], [{{:"$1", :"$2"}}]}
           ]),
         %User{} <- Auth.get_user(id) do
      GenServer.call(pid, {:take_state, keys})
    else
      _ -> :not_found
    end
  end

  def take_state(id, keys) when is_pid(id) do
    GenServer.call(id, {:take_state, keys})
  end

  def get_exporter_pid(keyword) do
    with [{pid, _user_id}] <- Registry.lookup(@registry, keyword),
         %{exporter_sup: sup_pid} <- take_state(pid, [:exporter_sup]),
         [{_id, child_pid, _type, _modules}] when is_pid(child_pid) <-
           Supervisor.which_children(sup_pid) do
      {:ok, child_pid}
    else
      err ->
        {:error, err}
    end
  end

  def submit_vote(keyword, %Vote{} = vote) do
    call_via_registry(keyword, {:submit_vote, vote})
  end

  def submit_text(keyword, %Text{} = text) do
    cast_via_registry(keyword, {:submit_text, text})
  end

  def conclude(keyword) do
    GenServer.stop(via_registry(keyword))
  end

  @impl GenServer
  def init(%__MODULE__{host_id: _, keyword: keyword} = live_session) do
    child = [{Kritikos.Exporter, self()}]
    {:ok, exporter_sup_pid} = Supervisor.start_link(child, strategy: :one_for_one)

    init_session =
      live_session
      |> Map.put(:start_datetime, DateTime.utc_now())
      |> Map.put(:exporter_sup, exporter_sup_pid)
      |> Map.put(:votes, [])
      |> Map.put(:texts, [])

    Logger.info("Launching session: " <> keyword)

    {:ok, init_session}
  end

  @impl GenServer
  def handle_call({:take_state, keys}, _from, state) do
    taken = Map.take(state, keys)

    if Enum.empty?(taken) do
      {:reply, :not_found, state}
    else
      {:reply, taken, state}
    end
  end

  @impl GenServer
  def handle_call({:submit_vote, %Vote{} = vote}, _from, state) do
    if has_already_voted?(state.votes, vote.voter_number) do
      new_votes =
        Enum.map(state.votes, fn vote_ ->
          if vote_.voter_number == vote.voter_number do
            %{vote_ | vote_level_id: vote.vote_level_id}
          else
            vote_
          end
        end)

      {:reply, vote.voter_number, %{state | votes: new_votes}}
    else
      voter_number = Enum.count(state.votes)
      vote = %{vote | voter_number: voter_number}
      {:reply, voter_number, %{state | votes: [vote | state.votes]}}
    end
  end

  @impl GenServer
  def handle_cast({:submit_text, %Text{} = text}, state) do
    if text_vote_is_suitable(text) do
      if has_already_voted?(state.texts, text.voter_number) do
        new_texts =
          Enum.map(state.texts, fn text_ ->
            if text_.voter_number == text.voter_number do
              %{text_ | text: text.text}
            else
              text_
            end
          end)

        {:noreply, %{state | texts: new_texts}}
      else
        {:noreply, %{state | texts: [text | state.texts]}}
      end
    else
      {:noreply, state}
    end
  end

  @impl GenServer
  def terminate(_reason, state) do
    resolved_session_id = ResolvedSession.create(state)

    Logger.info(
      "Terminating session: " <>
        state.keyword <> ", stored as id: " <> Integer.to_string(resolved_session_id)
    )

    {_count, resolved_votes} = Votes.ResolvedVote.create_all(resolved_session_id, state.votes)
    Votes.ResolvedTextual.create_all(state.texts, resolved_votes)
  end

  defp call_via_registry(keyword, request) do
    GenServer.call(via_registry(keyword), request)
  end

  defp cast_via_registry(keyword, request) do
    GenServer.cast(via_registry(keyword), request)
  end

  defp via_registry(keyword) do
    {:via, Registry, {@registry, keyword}}
  end

  defp has_already_voted?(enum, voter_number) do
    Enum.find_value(enum, false, fn e ->
      e.voter_number == voter_number
    end)
  end

  defp text_vote_is_suitable(text) do
    not String.valid?(text) || text != "" || not String.printable?(text) ||
      String.length(text) != 0
  end
end
