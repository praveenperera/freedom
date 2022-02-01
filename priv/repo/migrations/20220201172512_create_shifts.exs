defmodule Freedom.Repo.Migrations.CreateShifts do
  use Ecto.Migration

  def change do
    create table(:shifts) do
      add :start, :naive_datetime
      add :end, :naive_datetime
      add :vehicle, :string

      timestamps()
    end
  end
end
