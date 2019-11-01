defmodule Kritikos.Exporter do
  @moduledoc """
  Manages generation of export assets for LiveSessions
  """
  use GenServer
  alias Kritikos.Sessions.LiveSession

  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg)
  end

  def qr_code_png_binary(exporter_pid) do
    GenServer.call(exporter_pid, {:qr_code_png_binary}, :infinity)
  end

  @impl GenServer
  def init(parent_pid) do
    {:ok, %{parent_pid: parent_pid}}
  end

  @impl GenServer
  def handle_call({:qr_code_png_binary}, _from, state) do
    existing_binary = Map.get(state, :qr_code_png_binary)

    if existing_binary != nil do
      {:reply, {:ok, existing_binary}, state}
    else
      case make_new_qr_code_png_binary(state[:parent_pid]) do
        {:ok, qr_code_png_binary} ->
          updated_state = Map.put(state, :qr_code_png_binary, qr_code_png_binary)

          {:reply, {:ok, qr_code_png_binary}, updated_state}

        {:error, _reason} = err ->
          {:reply, err, state}
      end
    end
  end

  defp make_new_qr_code_png_binary(pid) do
    with {:host, host} <-
           List.keyfind(Application.get_env(:kritikos, KritikosWeb.Endpoint)[:url], :host, 0),
         {:port, port_str} <-
           List.keyfind(Application.get_env(:kritikos, KritikosWeb.Endpoint)[:http], :port, 0),
         port <-
           Integer.to_string(port_str),
         %{keyword: keyword} <-
           LiveSession.take_state(pid, [:keyword]) do
      new_png =
        ("http://" <> host <> ":" <> port <> "/" <> keyword)
        |> EQRCode.encode()
        |> EQRCode.png()

      {:ok, new_png}
    else
      _ ->
        {:error, "could not generate png"}
    end
  end
end
