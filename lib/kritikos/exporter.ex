defmodule Kritikos.Exporter do
  use GenServer

  defstruct []

  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg)
  end

  def init(parent_pid) when is_pid(parent_pid) do
    Process.monitor(parent_pid)
    {:ok, %{}}
  end
end
