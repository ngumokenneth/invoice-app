defmodule InvoiceAppWeb.Avatar.AvatarLive do
  use InvoiceAppWeb, :live_view
  alias InvoiceApp.Accounts

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="h-screen grid-cols-2 lg:grid">
      <div class="hidden overflow-hidden lg:block">
        <div class="overflow-hidden lg:block">
          <img src="../images/cover_image.png" alt="" />
        </div>
      </div>
      <div class="flex flex-col items-center justify-center h-full">
        <div class="flex flex-col justify-center max-w-sm mx-auto md:max-w-lg lg:max-w-sm">
          <div class="flex items-center w-full lg:justify-center">
            <div>
              <img src="../images/logo.svg" alt="company logo" class="w-10" />
            </div>
            <p class="text-[#7C5DFA] px-4 font-bold text-3xl">Invoice</p>
          </div>
          <.header class="flex flex-col w-full ">
            <div class="py-12 lg:py-6">
              <p class="text-xl font-semi-bold lg:font-bold lg:text-xl">
                Welcome let's create your profile
                <span class="text-[#979797] w-full block font-light text-start text-lg py-3">
                  Just a few more steps...
                </span>
              </p>
            </div>
          </.header>
          <h2 class="font-semibold lg:text-xl">Add an Avatar</h2>
          <div class="grid grid-cols-3 pt-8">
            <section phx-drop-target={@uploads.avatar.ref} class="flex items-center ">
              <div class="rounded-full  w-12 h-12 border-2 border-dashed overflow-hidden border-[#979797] md:h-24 md:w-24">
                <img src={@current_user.avatar} alt="" class="" />
              </div>
              <%= for entry <- @uploads.avatar.entries do %>
                <article class="upload-entry">
                  <figure>
                    <.live_img_preview entry={entry} data-role="image-preview" />
                    <figcaption><%= entry.client_name %></figcaption>
                  </figure>
                  <%= for err <- upload_errors(@uploads.avatar, entry) do %>
                    <p class="alert alert-danger"><%= error_to_string(err) %></p>
                  <% end %>
                </article>
              <% end %>
              <%= for err <- upload_errors(@uploads.avatar) do %>
                <p class="alert alert-danger"><%= error_to_string(err) %></p>
              <% end %>
            </section>

            <form
              id="upload-form"
              phx-submit="save"
              phx-change="validate"
              class="flex flex-col items-end col-span-2 text-white "
            >
              <label class=" w-28 text-center my-auto mx-9 py-1 bg-[#7C5DFA] rounded-full
              md:mx-24 hover:cursor-pointer">
                <.live_file_input class="hidden mt-8" upload={@uploads.avatar} />
                <span>Choose Image</span>
              </label>
              <button
                type="submit"
                navigate={~p"/users/address"}
                class="bg-[#979797] w-32 rounded-full py-1  md:mx-12  translate-y-16 lg:translate-y-4 font-medium"
              >
                <.link navigate={~p"/users/address"}>Continue</.link>
              </button>
            </form>
          </div>
        </div>
      </div>
      <div class="w-full overflow-hidden bg-red-400 lg:hidden">
        <img src="../images/footer_rectangle.png" alt="" class="object-cover w-full" />
      </div>
    </div>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, session, socket) do
    user = InvoiceApp.Accounts.get_user_by_session_token(session["user_token"])

    {:ok,
     socket
     |> assign(:current_user, user)
     |> assign(:uploaded_files, [])
     |> allow_upload(:avatar, accept: ~w(.jpg .jpeg), max_entries: 2)}
  end

  @impl Phoenix.LiveView
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :avatar, ref)}
  end

  @impl Phoenix.LiveView
  def handle_event("save", _params, socket) do
    case consume_uploads(socket) do
      [] ->
        {:noreply, socket}

      [hd | _] ->
        user =
          socket.assigns.current_user
          |> IO.inspect(label: "user data")

        attrs =
          %{avatar: hd}
          |> IO.inspect(label: "attrs data")

        case Accounts.update_user(user, attrs) do
          {:ok, user} ->
            {:noreply,
             socket
             |> assign(:current_user, user)}

          {:error, %Ecto.Changeset{} = _changeset} ->
            {:noreply, socket}
        end
    end
  end

  defp consume_uploads(socket) do
    consume_uploaded_entries(socket, :avatar, fn %{path: path}, entry ->
      IO.inspect(path)
      IO.inspect(entry)

      dest =
        Path.join(["priv", "static", "uploads", Path.basename(path)])
        |> IO.inspect(label: "destination string")

      File.cp!(path, dest)
      {:ok, ~p"/uploads/#{Path.basename(dest)}"}
    end)
  end

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
