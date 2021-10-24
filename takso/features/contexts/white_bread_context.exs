defmodule WhiteBreadContext do
  use WhiteBread.Context
  use Hound.Helpers

  feature_starting_state fn  ->
    Application.ensure_all_started(:hound)
    %{}
  end
  scenario_starting_state fn _state ->
    Hound.start_session
    %{}
  end
  scenario_finalize fn _status, _state ->
    # Hound.end_session
    nil
  end

  given_ ~r/^the following taxis are on duty$/, fn state ->
    {:ok, state}
  end

  and_ ~r/^I want to go from "(?<argument_one>[^"]+)" to "(?<argument_two>[^"]+)"$/,
  fn state, %{argument_one: _argument_one,argument_two: _argument_two} ->
    {:ok, state}
  end

  and_ ~r/^I open STRS' web page$/, fn state ->
    navigate_to "/bookings/new"
    {:ok, state}
  end

  and_ ~r/^I enter the booking information$/, fn state ->
    {:ok, state}
  end

  when_ ~r/^I summit the booking request$/, fn state ->
    {:ok, state}
  end

  then_ ~r/^I should receive a confirmation message$/, fn state ->
    {:ok, state}
  end


end
