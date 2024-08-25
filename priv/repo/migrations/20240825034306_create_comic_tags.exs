defmodule SbCascade.Repo.Migrations.CreateComicTags do
  use Ecto.Migration

  def change do
    create table(:comic_tags) do
      add :ordinal, :integer
      add :comic_id, references(:comics, on_delete: :nothing)
      add :tag_id, references(:tags, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:comic_tags, [:comic_id])
    create index(:comic_tags, [:tag_id])
  end
end
