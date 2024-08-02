defmodule SbCascade.Repo.Migrations.CreateFiles do
  use Ecto.Migration

  def change do
    create table(:files) do
      add :name, :string, null: false
      add :width, :integer
      add :height, :integer
      add :url, :string, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
