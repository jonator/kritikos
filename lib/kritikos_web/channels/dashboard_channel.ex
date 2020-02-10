defmodule KritikosWeb.DashboardChannel do
  use Phoenix.Channel

  def join("dashboard:" <> user_id, _payload, socket) do
    Phoenix.PubSub.subscribe(Kritikos.PubSub, "update_model:#{user_id}")
    {:ok, socket}
  end

  def handle_info({:update_model, model}, socket) do
    push(socket, "update_model", model)
    {:noreply, socket}
  end
end
