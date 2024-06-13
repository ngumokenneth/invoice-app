defmodule InvoiceAppWeb.UserConfirmationInstructionsLiveTest do
  use InvoiceAppWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import InvoiceApp.AccountsFixtures

  alias InvoiceApp.Accounts
  alias InvoiceApp.Repo

  setup %{conn: conn} do
    password = valid_user_password()
    user = user_fixture(%{password: password})
    %{conn: log_in_user(conn, user), user: user, password: password}
  end

  describe "Resend confirmation" do
    test "renders the resend confirmation page", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/users/confirm")

      assert html =~ "Please follow the link in the message to confirm your email address."
    end
  end
end
