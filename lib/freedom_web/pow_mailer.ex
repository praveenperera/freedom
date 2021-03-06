defmodule FreedomWeb.PowMailer do
  use Pow.Phoenix.Mailer
  use Bamboo.Mailer, otp_app: :freedom
  import Bamboo.Email

  @from_email "support@freedom.com"

  @impl true
  def cast(%{user: user, subject: subject, text: text, html: html}) do
    new_email(
      to: user.email,
      from: @from_email,
      subject: subject,
      html_body: html,
      text_body: text
    )
  end

  @impl true
  def process(email) do
    deliver_later(email)
  end
end
