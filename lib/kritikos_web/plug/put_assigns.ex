defmodule KritikosWeb.Plug.PutAssigns do
  @moduledoc """
  Adds key-vals to Plug.Conn struct
  """
  @behaviour Plug

  def init(opts), do: opts

  def call(conn, [{key, val} | params]) do
    call(%{conn | assigns: Map.merge(conn.assigns, Map.new([{key, val}]))}, params)
  end

  def call(conn, []) do
    conn
  end
end
