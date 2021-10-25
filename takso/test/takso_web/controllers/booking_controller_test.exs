defmodule TaksoWeb.BookingControllerTest do
  use TaksoWeb.ConnCase
  alias Takso.{Repo,Sales.Taxi}

  test "Booking rejection", %{conn: conn} do
    conn = get build_conn(), "/"
    Repo.insert!(%Taxi{status: "busy"})
    conn = post conn, "/bookings", %{booking: [pickup_address: "Liivi 2", dropoff_address: "Lõunakeskus", distance: 1]}
    conn = get conn, redirected_to(conn)
    # assert html_response(conn, 200) =~ ~r/At present, there is no taxi available!/
  end

  test "Booking aceptance", %{conn: conn} do
    Repo.insert!(%Taxi{status: "available"})
    conn = post conn, "/bookings", %{booking: [pickup_address: "Liivi 2", dropoff_address: "Lõunakeskus", distance: 1]}
    conn = get conn, redirected_to(conn)
    assert html_response(conn, 200) =~ ~r/Your taxi will arrive in \d+ minutes/
  end

  test "booking requires a 'pickup address'", %{conn: conn}  do
    conn = post conn, "/bookings", %{booking: [pickup_address: nil, dropoff_address: "Lõunakeskus", distance: 1]}
    conn = get conn, redirected_to(conn)
    assert html_response(conn, 200) =~ ~r/blank/
  end

end
