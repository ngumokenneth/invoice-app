defmodule InvoiceAppWeb.UserConfirmationInstructionsLive do
  use InvoiceAppWeb, :live_view

  alias InvoiceApp.Accounts

  def render(assigns) do
    ~H"""
    <div class="flex items-center h-screen">
      <div class="max-w-sm mx-auto bg-[#7C5DFA33] p-8 md:max-w-lg rounded-lg">
        <%= if @current_user do %>
          <%= if @current_user.confirmed_at do %>
            <.header>
              You have already confirmed your account
            </.header>
          <% else %>
            <.confirm_instruction :if={@email} form={@form} email={@email} />
            <.confirm_email_form :if={!@email} form={@form} />
          <% end %>
        <% else %>
          <.confirm_instruction :if={@email} form={@form} email={@email} />
          <.confirm_email_form :if={!@email} form={@form} />
        <% end %>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    IO.inspect(socket)
    {:ok, assign(socket, form: to_form(%{}, as: "user"))}
  end

  def handle_params(%{"email" => email}, _uri, socket) do
    case Accounts.get_user_by_email(email) do
      %{email: ^email, confirmed_at: nil} = _user ->
        {:noreply, assign(socket, email: email)}

      _user_or_nil ->
        {:noreply, push_patch(socket, to: ~p"/users/confirm")}
    end
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, assign(socket, email: nil)}
  end

  def handle_event("send_instructions", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_confirmation_instructions(
        user,
        &url(~p"/users/confirm/#{&1}")
      )
    end

    info =
      "If your email is in our system and it has not been confirmed yet, you will receive an email with instructions shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end

  def handle_event("send_instructions", _params, socket) do
    if user = Accounts.get_user_by_email(socket.assigns.email) do
      Accounts.deliver_user_confirmation_instructions(
        user,
        &url(~p"/users/confirm/#{&1}")
      )
    end

    info =
      "We've sent a confirmation email. Please follow the link in the message to confirm your email address."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end

  defp confirm_instruction(assigns) do
    ~H"""
    <.header class="text-left">
      <p class="font-bold">Confirm your Email  Address.</p>
      <:subtitle>
        We've sent a confirmation email to
        <span class="font-bold text-black"><%= assigns.current_user.email %>.</span>
        <br /> Please follow the link in the message to confirm your email address. <br />
        If you did not receive the email, please check your spam folder or:
      </:subtitle>
    </.header>

    <.form for={@form} id="resend_confirmation_form" phx-submit="send_instructions">
      <.input field={@form[:email]} type="email" placeholder="Email" required />

      <.button phx-disable-with="Sending..." class="w-full my-5">
        Resend confirmation instructions
      </.button>
    </.form>
    """
  end

  defp confirm_email_form(assigns) do
    ~H"""
    <div class="">
      <.header class="text-center">
        No confirmation instructions received?
        <:subtitle>We'll send a new confirmation link to your inbox</:subtitle>
      </.header>

      <.form for={@form} id="resend_confirmation_form" phx-submit="send_instructions">
        <.input field={@form[:email]} type="email" placeholder="Email" required />

        <.button phx-disable-with="Sending..." class="w-full mt-4">
          Resend confirmation instructions
        </.button>
      </.form>

      <p class="mt-4 text-center">
        <.link href={~p"/users/register"}>Register</.link>
        | <.link href={~p"/users/log_in"}>Log in</.link>
      </p>
    </div>
    """
  end
end
