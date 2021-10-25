defmodule TaksoWeb.BookingController do
  use TaksoWeb, :controller

  alias Takso.Repo
  alias Takso.Sales.Taxi
  alias Takso.Sales.Booking
  alias Takso.Accounts.User

  import Ecto.Query, only: [from: 2]
  alias Ecto.Changeset

  def index(conn, _params) do
    bookings = Repo.all(from b in Booking, where: b.user_id == ^conn.assigns.current_user.id)
    render conn, "index.html", bookings: bookings
  end

  def new(conn, _params) do
    changeset = Booking.changeset(%Booking{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn,  %{"booking" => booking_params}) do
    # User
    user = conn.assigns.current_user

    # booking_struct = Ecto.build_assoc(user, :bookings, Enum.map(booking_params, fn({key, value}) -> {String.to_atom(key), value} end))

    # Status
    query = from t in Taxi, where: t.status == "available", select: t
    available_taxis = Takso.Repo.all(query)

    available = length(available_taxis) > 0

    type = if available, do: :info, else: :error
    msg = if available, do: "Your taxi will arrive in 5 minutes", else: "At present, there is no taxi available!"

    changeset = updateBookingStatus(available, booking_params, user)

    case Repo.insert(changeset) do
      {:ok, _} ->
          conn |> put_flash(type, msg)
               |> redirect(to: Routes.booking_path(conn, :new))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end


  end

  defp updateBookingStatus(available, booking_params, user) do
    st = if available, do: "ACCEPTED", else: "REJECTED"

    Booking.changeset(%Booking{}, booking_params)
                |> Changeset.put_change(:status, st)
                |> Changeset.put_change(:user, user)
  end


end
