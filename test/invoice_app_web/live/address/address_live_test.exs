defmodule InvoiceAppWeb.Address.AddressLiveTest do
  use InvoiceAppWeb.ConnCase, async: true
  import InvoiceApp.AccountsFixtures
  import Phoenix.LiveViewTest

  setup %{conn: conn} do
    password = valid_user_password()
    user = user_fixture(%{password: password}) |> confirm_email()
    %{conn: log_in_user(conn, user), user: user, password: password}
  end

  describe "address details page" do
    test "a user can access the page", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/users/address")
      assert html =~ "Enter your business address details"
    end

    test "user can access the input fields", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/users/address")
      country_field = element(view, "input#address_country")
      assert(has_element?(country_field))
    end

    test "user can submit address details", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/users/address")

      view
      |> form("form#address_form", %{
        "address" => %{
          "country" => "Kenya",
          "city" => "voi",
          "street_address" => "4567",
          "phone_number" => "12347098",
          "postal_code" => "57864"
        }
      })
      |> render_submit()
    end
  end
end
