defmodule SbCascade.Repo.Migrations.AlterComicTags do
  use Ecto.Migration

  def up do
    drop table(:comic_tags)

    create table(:comic_tags) do
      add :ordinal, :integer
      add :comic_id, references(:comics, on_delete: :delete_all)
      add :tag_id, references(:tags, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:comic_tags, [:comic_id])
    create index(:comic_tags, [:tag_id])
  end

  def down do
    drop table(:comic_tags)

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
