defmodule InvoiceAppWeb.Address.AddressLive do
  use InvoiceAppWeb, :live_view
  alias InvoiceApp.Accounts
  alias InvoiceApp.Accounts.Address

  def render(assigns) do
    ~H"""
    <section class="h-screen grid-cols-2 lg:grid ">
      <div class="hidden overflow-hidden lg:block ">
        <div class="lg:block">
          <img src="../images/cover_image.png" alt="" class="object-cover w-full" />
        </div>
      </div>

      <div class="flex flex-col items-center justify-center max-w-sm mx-auto">
        <div class="w-full px-5">
          <.header>
            <div class="relative hidden lg:block right-10">
              <div class="flex items-center">
                <img src="../images/right_arrow.svg" alt="" />
                <span class="text-[#7C5DFA] text-xs"><.link navigate={~p"/"}>Back</.link></span>
              </div>
            </div>
            <div class="flex flex-col justify-center lg:mt-12 lg:items-center lg:w-11/12">
              <div class="flex items-center ">
                <img src="../images/logo.svg" alt="company logo" class="w-10 " />
                <p class="text-[#7C5DFA] px-4 font-bold text-3xl lg:text-4xl">Invoice</p>
              </div>
              <p class="py-3 text-sm font-semibold lg:text-center lg:pt-12 lg:w-full">
                Enter your business address details:
              </p>
            </div>
          </.header>
          <div class="w-full">
            <.simple_form
              for={@form}
              id="address_form"
              phx-change="validate"
              phx-submit="save_address"
              action={~p"/users/address"}
            >
              <div class="gap-4 space-y-6 lg:flex lg:space-y-0 lg:justify-between">
                <.input
                  field={@form[:country]}
                  type="text"
                  placeholder="Choose Your Country"
                  phx-debounce="blur"
                  label="Country"
                >
                  Country
                </.input>
                <.input
                  field={@form[:city]}
                  label="City"
                  type="text"
                  placeholder="City Name"
                  phx-debounce="blur"
                >
                  city
                </.input>
              </div>
              <.input
                field={@form[:street_address]}
                placeholder="Street Address"
                label="Street Address"
                phx-debounce="blur"
              >
                Street Address
              </.input>
              <.input
                field={@form[:postal_code]}
                label="Postal Code"
                placeholder="Postal Code"
                phx-debounce="blur"
              >
                Postal Code
              </.input>
              <.input
                field={@form[:phone_number]}
                label="Phone Number"
                placeholder="Phone Number"
                phx-debounce="blur"
              >
                Postal Code
              </.input>
              <div class="flex gap-4 py-5 lg:justify-end place-content-between">
                <.button class="lg:hidden px-16 rounded-full text-black bg-[#FFFFFF] border">
                  <.link navigate={~p"/users/address"}>Back</.link>
                </.button>
                <.button phx-disable-with="Saving..." class=" rounded-full bg-[#7C5DFA] w-32 py-1">
                  Save
                </.button>
              </div>
            </.simple_form>
          </div>
        </div>
      </div>
    </section>
    """
  end

  def mount(_params, _session, socket) do
    form = to_form(Address.changeset(%Address{}), as: "address")

    {:ok,
     socket
     |> assign(trigger_submit: false, check_errors: false)
     |> assign(:form, form)}
  end

  def handle_event("validate", %{"address" => address_params}, socket) do
    form =
      %Address{}
      |> Address.changeset(address_params)
      |> Map.put(:action, :validate)
      |> to_form(as: "address")

    {:noreply, assign(socket, :form, form)}
  end

  def handle_event("save_address", params, socket) do
    user =
      socket.assigns.current_user

    case Accounts.update_user(user, params) do
      {:ok, user} ->
        {:noreply,
         socket
         |> assign(current_user: user)
         |> put_flash(:info, "Address updated successfully")
         |> push_redirect(to: "/")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> assign(check_errors: true)
         |> assign(:form, to_form(changeset, as: "address"))
         |> put_flash(:info, "Failed to update address")}
    end
  end
end
