defmodule Kritikos.Exporter do
  @moduledoc """
  Manages generation of export assets
  """
  def qr_code_png_binary(url) do
    EQRCode.encode(url)
    |> EQRCode.png()
  end
end
