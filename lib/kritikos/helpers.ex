defmodule Kritikos.Helpers do
  @moduledoc """
  General helpers for Kritikos app functionality.
  """
  alias Kritikos.Repo

  def get_schema(schema, id, opts \\ [])
  def get_schema(schema, id, []), do: Repo.get(schema, id)
  def get_schema(schema, id, preload: key), do: get_schema(schema, id) |> Repo.preload(key)
end
