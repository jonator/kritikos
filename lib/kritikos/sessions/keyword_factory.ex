defmodule Kritikos.Sessions.KeywordFactory do
  @moduledoc """
  Manages the creation of keywords
  """
  use Agent
  require Logger
  alias Kritikos.Sessions

  @keyword_filepath Application.get_env(:kritikos, __MODULE__)[:keyword_file_path]

  def start_link(_) do
    case File.read(@keyword_filepath) do
      {:ok, binary} ->
        words = String.split(binary, "\n", trim: true)
        Agent.start_link(fn -> MapSet.new(words) end, name: __MODULE__)

      {:error, reason} ->
        Logger.error("failed to read keyword file")
        {:error, "webpack not run: " <> Atom.to_string(reason)}
    end
  end

  def next_available_for_user(user_id) do
    Agent.get_and_update(__MODULE__, fn map_set ->
      case MapSet.to_list(map_set) do
        [_word | _rest_words] = words ->
          taken_keywords =
            Sessions.sessions_for_user(user_id)
            |> Enum.map(fn session -> session.keyword end)
            |> Enum.uniq()

          {avail_word, all_words} = next_untaken_word(words, taken_keywords)

          {avail_word, MapSet.new(all_words)}

        [] ->
          {gen_short_id(), map_set}
      end
    end)
  end

  def next_untaken_word([word | [next_word | words]], exclude_list) do
    if Enum.member?(exclude_list, word) do
      next_untaken_word([next_word | words ++ [word]], exclude_list)
    else
      {word, [next_word | words]}
    end
  end

  def next_untaken_word([], _) do
    {gen_short_id(), []}
  end

  defp gen_short_id do
    Ecto.UUID.generate() |> String.split("-") |> hd()
  end
end
