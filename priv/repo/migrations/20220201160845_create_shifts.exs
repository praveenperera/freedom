defmodule Freedom.Repo.Migrations.CreateShifts do
  use Ecto.Migration

  def change do
    create table(:shifts) do
      add :vehicle, :string
      add :start, :naive_datetime
      add :end, :naive_datetime

      add :user_id, references(:users)
      add :city_id, references(:cities)

      timestamps()
    end

    create index(:shifts, [:user_id])
    create index(:shifts, [:city_id])
  end
end
