defmodule KritikosWeb.VotesReports do
  alias Kritikos.Votes
  @week_in_seconds 604_800

  def unviewed_prior(:weekly) do
    now = DateTime.utc_now()
    start_of_prev_week = DateTime.add(now, -@week_in_seconds)
    Votes.unviewed_votes_in_datetimes(start_of_prev_week, now)
  end

  def unviewed_prior(:monthly) do
    now = DateTime.utc_now()

    first_day_last_month =
      now
      |> DateTime.to_date()
      |> Date.beginning_of_month()
      |> Date.add(-1)
      |> Date.beginning_of_month()
      |> DateTime.new!(Time.new!(0, 0, 0))
      |> IO.inspect()

    Votes.unviewed_votes_in_datetimes(first_day_last_month, now)
  end
end
