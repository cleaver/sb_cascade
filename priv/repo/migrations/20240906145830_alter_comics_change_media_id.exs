defmodule SbCascade.Repo.Migrations.AlterComicsChangeMediaId do
  use Ecto.Migration

  def up do
    drop constraint(:comics, "comics_media_id_fkey")

    alter table(:comics) do
      modify :media_id, references(:files, on_delete: :nilify_all)
    end
  end

  def down do
    drop constraint(:comics, "comics_media_id_fkey")

    alter table(:comics) do
      modify :media_id, references(:files, on_delete: :nothing)
    end
  end
end
