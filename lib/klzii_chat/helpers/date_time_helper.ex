defmodule KlziiChat.Helpers.DateTimeHelper do
  use Timex
  def report_format(time, time_zone) do
    Ecto.DateTime.to_erl(time)
    |> Timex.to_datetime
    |> Timezone.convert(time_zone)
    |> Timex.format!( "%a %b %d %Y %H:%0M %Z", :strftime)
  end
end
