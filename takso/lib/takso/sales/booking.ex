defmodule Takso.Sales.Booking do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bookings" do
    field :distance, :decimal
    field :dropoff_address, :string
    field :pickup_address, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(booking, attrs) do
    booking
    |> cast(attrs, [:pickup_address, :dropoff_address, :distance, :status])
    |> validate_required([:pickup_address, :dropoff_address, :distance])
  end
end
