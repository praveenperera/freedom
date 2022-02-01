# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Freedom.Repo.insert!(%Freedom.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Freedom.Repo.insert!(%Freedom.Protest.City{
  name: "Edmonton",
  province: "Alberta",
  timezone: "America/Edmonton"
})
