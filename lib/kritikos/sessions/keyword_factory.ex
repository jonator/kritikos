defmodule Kritikos.Sessions.KeywordFactory do
  @moduledoc """
  Manages the creation of keywords
  """
  use Agent
  require Logger

  @keyword_filepath Application.get_env(:kritikos, __MODULE__)[:keyword_file_path]

  def start_link(_) do
    case File.read(@keyword_filepath) do
      {:ok, binary} ->
        words = String.split(binary, "\n", trim: true)
        Agent.start_link(fn -> MapSet.new(words) end, name: __MODULE__)

      {:error, _} ->
        Logger.error("failed to read keyword file")
        {:error, "failed to read file"}
    end
  end

  def next_available do
    Agent.get_and_update(__MODULE__, fn map_set ->
      case MapSet.to_list(map_set) do
        [word | words] ->
          {word, MapSet.new(words)}

        [] ->
          id = Ecto.UUID.generate() |> String.split("-") |> hd()
          {id, map_set}
      end
    end)
  end
end
