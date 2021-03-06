defmodule TaksoWeb.BookingController do
  use TaksoWeb, :controller

  alias Takso.Repo
  alias Takso.Sales.Taxi
  alias Takso.Sales.Booking

  import Ecto.Query, only: [from: 2]
  alias Ecto.Changeset

  def new(conn, _params) do
    changeset = Booking.changeset(%Booking{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn,  %{"booking" => booking_params}) do
    query = from t in Taxi, where: t.status == "available", select: t
    available_taxis = Takso.Repo.all(query)

    available = length(available_taxis) > 0

    type = if available, do: :info, else: :error
    msg = if available, do: "Your taxi will arrive in 5 minutes", else: "At present, there is no taxi available!"

    changeset = updateBookingStatus(available, booking_params)

    case Repo.insert(changeset) do
      {:ok, _} ->
          conn |> put_flash(type, msg)
               |> redirect(to: Routes.booking_path(conn, :new))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end


  end

  defp updateBookingStatus(available, booking_params) do
    st = if available, do: "ACCEPTED", else: "REJECTED"

    Booking.changeset(%Booking{}, booking_params)
                |> Changeset.put_change(:status, st)
  end


end
