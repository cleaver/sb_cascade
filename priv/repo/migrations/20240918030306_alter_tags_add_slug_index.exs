defmodule SbCascade.Repo.Migrations.AlterTagsAddSlugIndex do
  use Ecto.Migration

  def change do
    create unique_index(:tags, [:slug])
  end
end
