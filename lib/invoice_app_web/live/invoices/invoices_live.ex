defmodule InvoiceAppWeb.Invoices.InvoicesLive do
  use InvoiceAppWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="bg-[rgb(55,59,83)] flex justify-between h-44">
      <div class="bg-[#7C5DFA] rounded-r-[40px] relative  h-full overflow-hidden">
        <div class="absolute z-10 flex items-center justify-center w-full h-full">
          <img src="/images/images/logo_white.svg" alt="" class="w-16 h-16" />
        </div>
        <div class="bg-[#9277FF] w-44 rounded-tl-[40px]  mt-20 px-2 py-28 relative bottom-0"></div>
      </div>
      <div class="flex items-center h-full pr-8 overflow-hidden">
        <img src="/images/images/cresent.svg" alt="" class="w-16 h-16" />
        <div class="w-1 h-48 bg-[#494E6E] mx-10"></div>

        <div><img src="/images/images/user_icon.svg" alt="" class="w-20 h-20" /></div>
      </div>
    </div>
    """
  end
end
