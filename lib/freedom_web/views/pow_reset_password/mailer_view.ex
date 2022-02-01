defmodule FreedomWeb.PowResetPassword.MailerView do
  use FreedomWeb, :mailer_view

  def subject(:reset_password, _assigns), do: "Reset password link"
end
