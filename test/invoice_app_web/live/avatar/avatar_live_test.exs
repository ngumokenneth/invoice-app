defmodule InvoiceAppWeb.Avatar.AvatarLiveTest do
  use InvoiceAppWeb.ConnCase, async: true
  import InvoiceApp.AccountsFixtures
  import Phoenix.LiveViewTest

  setup %{conn: conn} do
    password = valid_user_password()
    user = user_fixture(%{password: password}) |> confirm_email()
    %{conn: log_in_user(conn, user), user: user, password: password}
  end

  describe "user avatar page" do
    test "user can access the avatar page", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/users/avatar")
      assert html =~ "Add an Avatar"
    end

    test "user can upload avatar", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/users/avatar")

      view
      |> file_input("#upload-form", :avatar, [
        %{
          name: "footer_rectangle.png",
          content: File.read!("test/support/images/footer_rectangle.png"),
          type: "image/png"
        }
      ])
      |> render_upload("footer_rectangle.png")

      assert has_element?(view, "[data-role='image-preview']")
    end

    test "user sees error when uploading too many files", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/users/avatar")

      view
      |> upload("footer_rectangle.png")
      |> upload("footer_rectangle.png")
      |> upload("footer_rectangle.png")

      assert render(view) =~ "You have selected too many files"
    end
  end

  defp upload(view, filename) do
    view
    |> file_input("#upload-form", :avatar, [
      %{
        name: filename,
        content: File.read!("test/support/images/#{filename}"),
        type: "image/png"
      }
    ])
    |> render_upload(filename)

    view
    |> form("#upload-form")
    |> render_change()

    view
  end
end
