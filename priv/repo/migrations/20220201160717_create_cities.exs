defmodule Freedom.Repo.Migrations.CreateCities do
  use Ecto.Migration

  def change do
    create table(:cities) do
      add :name, :string
      add :timezone, :string
      add :province, :string

      timestamps()
    end
  end
end
