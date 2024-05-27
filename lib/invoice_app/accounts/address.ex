defmodule InvoiceApp.Accounts.Address do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :country, :string
    field :city, :string
    field :postal_code, :string
    field :street_address, :string
    field :phone_number, :string
  end

  def changeset(%__MODULE__{} = address, attrs \\ %{}) do
    address
    |> cast(attrs, [:country, :city, :postal_code, :street_address, :phone_number])
    |> validate_required([:country, :city, :postal_code, :street_address, :phone_number])
  end
end
