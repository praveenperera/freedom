defmodule FreedomWeb.Live.ShiftLive.Helpers do
  def format(%Time{} = time), do: Calendar.strftime(time, "%I:%M%p")
  def format(%Date{} = day), do: Calendar.strftime(day, "%A – %B %-d")

  def slot_already_booked?(day, slot, shifts),
    do: Freedom.Protest.slot_already_booked?(day, slot, shifts)
end
