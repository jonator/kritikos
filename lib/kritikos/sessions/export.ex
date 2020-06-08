defmodule Kritikos.Sessions.Export do
  alias Kritikos.Sessions

  def export_qr_code(keyword) do
    session_url(keyword)
    |> qr_code_png_binary()
  end

  def generate_session_qr_code_grid_pdf(keyword) do
    prompt_question = Sessions.get_open(keyword).prompt_question

    qr_code_svg =
      EQRCode.encode(Kritikos.Application.fetch_host() <> "/" <> keyword)
      |> EQRCode.svg(width: 200)

    html =
      Sneeze.render([
        :html,
        [
          :body,
          %{
            style:
              style(%{
                "font-family" => "Helvetica",
                "font-size" => "15pt",
                "font-weight" => "bold",
                "width" => 880
              })
          },
          Enum.map(1..4, fn _ ->
            [
              :div,
              Enum.map(1..3, fn _ ->
                qr_code_block(qr_code_svg, prompt_question, keyword)
              end)
            ]
          end)
        ]
      ])

    PdfGenerator.generate(html,
      page_size: "A4",
      shell_params: ["--dpi", "300"]
    )
  end

  defp qr_code_block(qr_code_svg, prompt_question, keyword) do
    [
      :div,
      %{
        style:
          style(%{
            "display" => "block",
            "text-align" => "center",
            "width" => 293,
            "float" => "left"
          })
      },
      [:p, %{style: style(%{"margin-bottom" => "0"})}, prompt_question],
      [:__@raw_html, qr_code_svg],
      [:br],
      [:small, %{style: style(%{"font-size" => "10pt", "font-weight" => "normal"})}, keyword],
      [
        :p,
        %{style: style(%{"margin-top" => "0"})},
        "Scan with phone camera"
      ]
    ]
  end

  defp style(style_map) do
    style_map
    |> Enum.map(fn {key, value} ->
      "#{key}: #{value}"
    end)
    |> Enum.join(";")
  end

  defp qr_code_png_binary(url) do
    EQRCode.encode(url)
    |> EQRCode.png()
  end

  defp session_url(keyword) do
    Kritikos.Application.fetch_host() <> "/" <> keyword
  end
end
