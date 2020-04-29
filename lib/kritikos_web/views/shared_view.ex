defmodule KritikosWeb.SharedView do
  @pretty_print Mix.env() == :dev

  def to_js_object(data) do
    {:ok, json} = Jason.encode(data, escape: :javascript_safe, pretty: @pretty_print)

    {:safe, json}
  end
end
