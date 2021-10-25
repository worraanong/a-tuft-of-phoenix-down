defmodule Takso.Repo.Migrations.CreateBookings do
  use Ecto.Migration

  def change do
    create table(:bookings) do
      add :pickup_address, :string
      add :dropoff_address, :string
      add :distance, :decimal
      add :status, :string

      timestamps()
    end
  end
end
