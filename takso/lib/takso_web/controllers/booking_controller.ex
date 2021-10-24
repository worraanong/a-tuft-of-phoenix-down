defmodule TaksoWeb.BookingController do
  use TaksoWeb, :controller
  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, _params) do
    conn
    |> put_flash(:info, "Your taxi will arrive in 1 minutes")
    |> redirect(to: Routes.booking_path(conn, :new))
  end

end
