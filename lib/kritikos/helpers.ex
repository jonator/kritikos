defmodule Kritikos.Helpers do
  alias Kritikos.Repo

  def get_schema(schema, id, opts \\ [])
  def get_schema(schema, id, []), do: Repo.get(schema, id)
  def get_schema(schema, id, preload: key), do: get_schema(schema, id) |> Repo.preload(key)
end
