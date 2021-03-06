defmodule KritikosWeb.Email do
  @moduledoc """
  Defines emails for Kritikos feedbackers.
  """
  use Bamboo.Phoenix, view: KritikosWeb.EmailView

  def welcome(recipient, verify_email_token) do
    base_email()
    |> subject("Welcome to Kritikos!")
    |> to(recipient)
    |> render(:welcome,
      host: Kritikos.Application.fetch_host(),
      verify_email_token: verify_email_token
    )
  end

  def verify_email(recipient, verify_email_token) do
    base_email()
    |> subject("Verify email")
    |> to(recipient)
    |> render(:verify_email,
      host: Kritikos.Application.fetch_host(),
      verify_email_token: verify_email_token
    )
  end

  defp base_email do
    new_email()
    |> from("Kritikos Staff<support@kritikos.app>")
    |> put_html_layout({KritikosWeb.LayoutView, "email.html"})
  end
end
