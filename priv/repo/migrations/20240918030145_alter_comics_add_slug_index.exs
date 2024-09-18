defmodule SbCascade.Repo.Migrations.AlterComicsAddSlugIndex do
  use Ecto.Migration

  def change do
    create unique_index(:comics, [:slug])
  end
end
