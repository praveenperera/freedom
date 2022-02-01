defmodule Freedom.Mailing.Email do
  import Bamboo.Email
  use Bamboo.Phoenix, view: FreedomWeb.EmailView

  def base_email() do
    new_email()
    |> from(Application.get_env(:freedom, :email)[:from])
    |> put_html_layout({FreedomWeb.LayoutView, "email.html"})
  end
end
