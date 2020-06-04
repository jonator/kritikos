defmodule KritikosWeb.FormatHelpers do
  @moduledoc """
  Provides format-related functions.
  """
  def format_map_with_keys(map),
    do: format_map_with_keys(map, Map.keys(map))

  def format_map_with_keys(%_{} = struct, keys),
    do: Map.from_struct(struct) |> format_map_with_keys(keys)

  def format_map_with_keys(%{} = map, keys) do
    Map.take(map, keys)
    |> filter_missing_assocs_and_metadata()
    |> camelize()
  end

  def camelize([_ | _] = list), do: Enum.map(list, &camelize/1)
  def camelize(%DateTime{} = dt), do: dt
  def camelize(%NaiveDateTime{} = ndt), do: ndt
  def camelize(%Time{} = t), do: t

  def camelize(%_{} = struct),
    do: Map.from_struct(struct) |> camelize()

  def camelize(%{} = map) do
    map
    |> Enum.map(fn {key, value} ->
      {camelize_key(key), camelize(value)}
    end)
    |> Enum.into(%{})
  end

  def camelize(not_map), do: not_map

  defp camelize_key(key) when is_atom(key), do: key |> to_string |> camelize_key

  defp camelize_key(key) when is_bitstring(key) do
    key
    |> String.split("_")
    |> Enum.reduce([], &camel_case/2)
    |> Enum.join()
  end

  defp camel_case(item, []), do: [item]
  defp camel_case(item, list), do: list ++ [String.capitalize(item)]

  def filter_missing_assocs_and_metadata(map) do
    Enum.reduce(map, %{}, fn {key, value}, acc ->
      case value do
        %Ecto.Association.NotLoaded{} ->
          acc

        %_{__meta__: %Ecto.Schema.Metadata{}} = schema ->
          m = Map.from_struct(schema) |> Map.delete(:__meta__)
          Map.put(acc, key, filter_missing_assocs_and_metadata(m))

        [_ | _] = list ->
          new_list =
            Enum.map(list, fn listitem ->
              case listitem do
                %_{__meta__: %Ecto.Schema.Metadata{}} = schema ->
                  Map.from_struct(schema)
                  |> Map.delete(:__meta__)
                  |> filter_missing_assocs_and_metadata()

                _ ->
                  listitem
              end
            end)

          Map.put(acc, key, new_list)

        _ ->
          Map.put(acc, key, value)
      end
    end)
  end
end
