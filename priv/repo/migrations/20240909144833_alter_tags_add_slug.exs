defmodule SbCascade.Repo.Migrations.AlterTagsAddSlug do
  use Ecto.Migration

  def change do
    alter table(:tags) do
      add :slug, :string
    end
  end
end
