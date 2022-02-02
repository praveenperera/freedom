defmodule FreedomWeb.Live.ShiftLive.Helpers do
  def format(%Time{} = time), do: Calendar.strftime(time, "%I:%M%p")

  def slot_already_booked?(day, slot, shifts),
    do: Freedom.Protest.slot_already_booked?(day, slot, shifts)
end
