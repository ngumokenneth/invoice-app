defmodule InvoiceAppWeb.UserRegistrationLive do
  use InvoiceAppWeb, :live_view

  alias InvoiceApp.Accounts
  alias InvoiceApp.Accounts.User

  def render(assigns) do
    ~H"""
    <div class="max-h-screen grid-cols-2 lg:grid">
      <div class="hidden overflow-hidden lg:block">
        <img src="../images/cover_image.png" alt="" class="object-cover w-full h-full" />
        <div class="absolute flex items-center xl:right-[600px] z-10 top-10 lg:right-[450px] xl:top-20">
          <img src="../images/right_arrow.svg" alt="" />
          <span class="text-[#7C5DFA] text-xs"><.link navigate={~p"/"}>Back</.link></span>
        </div>
      </div>
      <div class="flex flex-col justify-center max-w-sm mx-auto  xl:w-[700px]">
        <div class="hidden pb-6 lg:block">
          <div class="flex items-center justify-center w-full gap-3">
            <img src="/images/logo.svg" alt="logo" class="h-16" />
            <h1 class="text-5xl font-extrabold text-[#7C5DFA]">Invoice</h1>
          </div>
        </div>
        <.header class="text-start">
          <p class="text-2xl font-bold md:text-4xl lg:text-center">Create an account</p>
          <:subtitle>
            <p class="md:text-xl lg:hidden">Begin creating invoices for free!</p>
          </:subtitle>
        </.header>
        <.simple_form
          for={@form}
          id="registration_form"
          phx-submit="save"
          phx-change="validate"
          method="post"
          class="pt-8"
        >
          <.error :if={@check_errors}>
            Oops, something went wrong! Please check the errors below.
          </.error>

          <.input field={@form[:name]} type="text" label="Name" required />
          <.input field={@form[:username]} type="text" label="Username" required />
          <.input field={@form[:email]} type="email" label="Email" required />
          <.input field={@form[:password]} type="password" label="Password" required />
          <:actions>
            <.button
              phx-disable-with="Creating account..."
              class="w-full font-bold bg-[#7C5DFA80;] lg:rounded-xl hover:bg-indigo-500"
            >
              Sign Up
            </.button>
          </:actions>
        </.simple_form>
        <p class="pt-6 text-center">
          Already have an account?
          <.link navigate={~p"/users/log_in"} class="font-semibold text-[#7C5DFA] hover:underline">
            Log in
          </.link>
        </p>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)

        {:noreply,
         socket
         |> assign(trigger_submit: true)
         |> assign_form(changeset)
         |> redirect(to: ~p"/users/confirm?#{[email: user.email]}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
