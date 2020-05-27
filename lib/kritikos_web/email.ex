defmodule KritikosWeb.Email do
  use Bamboo.Phoenix, view: KritikosWeb.EmailView

  def welcome(recipient, verify_email_token) do
    base_email()
    |> subject("Welcome to Kritikos!")
    |> to(recipient)
    |> render(:welcome, verify_email_token: verify_email_token)
  end

  defp base_email do
    new_email()
    |> from("Kritikos Staff<support@kritikos.app>")
    |> put_html_layout({KritikosWeb.LayoutView, "email.html"})
  end
end
