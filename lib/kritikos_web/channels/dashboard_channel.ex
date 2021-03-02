defmodule KritikosWeb.DashboardChannel do
  @moduledoc """
  Broadcases certain model updates to user WebSocket connections/channels.
  """
  use Phoenix.Channel
  alias Phoenix.PubSub

  def join("dashboard:" <> user_id, _payload, socket) do
    PubSub.subscribe(Kritikos.PubSub, "update_model:#{user_id}")
    {:ok, socket}
  end

  def broadcast_model_update(user_id, %_{} = model) do
    broadcast_model_update(user_id, Map.from_struct(model))
  end

  def broadcast_model_update(user_id, model) do
    PubSub.broadcast(Kritikos.PubSub, "dashboard:#{user_id}", {:update_model, model})
  end

  def handle_info({:update_model, model}, socket) when is_map(model) do
    format_model = KritikosWeb.FormatHelpers.format_map_with_keys(model, Map.keys(model))

    push(socket, "update_model", format_model)
    {:noreply, socket}
  end
end
