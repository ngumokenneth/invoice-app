defmodule InvoiceAppWeb.Invoices.InvoiceLive do
  use InvoiceAppWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Invoices</h1>
    """
  end
end
