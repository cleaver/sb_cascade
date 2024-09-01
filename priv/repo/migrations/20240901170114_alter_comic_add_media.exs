defmodule SbCascade.Repo.Migrations.AlterComicAddMedia do
  use Ecto.Migration

  def change do
    alter table(:comics) do
      add :media_id, references(:files, on_delete: :nothing)
    end

    create index(:comics, [:media_id])
  end
end
