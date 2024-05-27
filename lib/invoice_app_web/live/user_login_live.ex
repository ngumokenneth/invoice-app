defmodule InvoiceAppWeb.UserLoginLive do
  use InvoiceAppWeb, :live_view

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
            <img src="/images/logo.svg" alt="logo" class="h-12" />
            <h1 class="text-5xl font-extrabold text-[#7C5DFA]">Invoice</h1>
          </div>
        </div>
        <.header class="text-center ">
          <p class="text-2xl font-extrabold">Sign in to Invoice</p>
        </.header>
        <.simple_form
          for={@form}
          id="login_form"
          action={~p"/users/log_in"}
          phx-update="ignore"
          class="pt-2 space-y-12"
        >
          <.input field={@form[:email]} type="email" label="Email" required />
          <.input field={@form[:password]} type="password" label="Password" required />
          <:actions>
            <.input field={@form[:remember_me]} type="checkbox" label="Remember Me" />
            <.link href={~p"/users/reset_password"} class="text-sm font-semibold text-[#E86969]">
              Forgot your password?
            </.link>
          </:actions>
          <:actions>
            <.button phx-disable-with="Logging in..." class="w-full bg-[#7C5DFA;] lg:hidden">
              Login <span aria-hidden="true">→</span>
            </.button>
            <.button phx-disable-with="Logging in..." class="w-full bg-[#7C5DFA;] py-4 rounded-2xl hidden lg:block">
              Continue <span aria-hidden="true">→</span>
            </.button>
          </:actions>
        </.simple_form>
        <p class="pt-5 text-center">
          Don't have an account?
          <.link navigate={~p"/users/register"} class="font-semibold text-[#7C5DFA] hover:underline">
            Sign up
          </.link>
        </p>
        <div class="flex items-center justify-center gap-2 py-6 lg:hidden">
          <hr class="w-24 md:w-36" />
          <p>Or with</p>
          <hr class="w-24 md:w-36" />
        </div>
        <.button
          phx-disable-with="Logging in..."
          class="flex justify-center w-full gap-3 border bg-zinc-50 lg:hidden"
        >
          <img src="../images/google.svg" alt="Google logo" class="" />
          <span aria-hidden="true" class="text-black/60 ">Login with Google</span>
        </.button>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
