defmodule InvoiceAppWeb.Invoices.InvoicesLive do
  use InvoiceAppWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <%!-- mobile top-bar --%>
    <div class="bg-[rgb(55,59,83)] flex justify-between h-16 lg:hidden">
      <div class="bg-[#7C5DFA]  relative  h-full overflow-hidden rounded-r-2xl w-16">
        <div class="absolute z-10 flex items-center justify-center w-full h-full">
          <img src="/images/images/logo_white.svg" alt="" class="h-7 w-7" />
        </div>
        <div class="absolute bottom-0 w-full h-8 px-2 bg-[#9277FF] rounded-tl-2xl"></div>
      </div>
      <div class="flex items-center h-full mx-4 overflow-hidden ">
        <img src="/images/images/cresent.svg" alt="" class="h-7 w-7" />
        <div class="border h-48 bg-[#494E6E] mx-5"></div>
        <div><img src="/images/images/user_icon.svg" alt="" class="h-7 w-7" /></div>
      </div>
    </div>

    <%!-- desktop top-bar --%>
    <div class="hidden lg:block">
      <div class="bg-[rgb(55,59,83)] flex justify-between w-20 flex-col h-screen rounded-r-2xl">
        <div class="bg-[#7C5DFA] rounded-r-2xl h-20 flex flex-col relative items-center overflow-hidden">
          <div class="absolute z-10 flex items-center justify-center h-full">
            <img src="/images/images/logo_white.svg" alt="" class="h-7 w-7" />
          </div>
          <div class="absolute bottom-0 w-full h-10 bg-[#9277FF] rounded-tl-2xl"></div>
        </div>
        <div class="flex flex-col items-center my-4">
          <img src="/images/images/cresent.svg" alt="" class="h-7 w-7" />
          <div class="border w-full bg-[#494E6E] my-4"></div>
          <div><img src="/images/images/user_icon.svg" alt="" class="w-10 h-10" /></div>
        </div>
      </div>
    </div>

    <div class="flex items-center justify-between px-2 py-6">
      <div>
        <p class="text-xl font-extrabold">Invoices</p>
        <p class="text-xs">No invoices</p>
      </div>
      <div class="flex font-bold">
        <div class="flex items-center">
          <p>Filter</p>
          <img src="/images/Path 2.svg" alt="" class="px-3" />
        </div>
        <div class="flex items-center bg-[#7C5DFA]  p-1 rounded-full">
          <img src="/images/+.svg" alt="" class="w-12 h-12 p-4 bg-white rounded-full" />
          <button class="px-2">New</button>
        </div>
      </div>
    </div>
    """
  end
end
