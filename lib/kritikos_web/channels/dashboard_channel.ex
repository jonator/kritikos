defmodule KritikosWeb.DashboardChannel do
  use Phoenix.Channel

  def join("dashboard:" <> _user_id, _payload, socket) do
    {:ok, socket}
  end
end
