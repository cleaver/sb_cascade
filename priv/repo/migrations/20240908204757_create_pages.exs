defmodule SbCascade.Repo.Migrations.CreatePages do
  use Ecto.Migration

  def change do
    create table(:pages) do
      add :title, :string
      add :body, :text
      add :slug, :string
      add :meta_description, :string
      add :image_alt_text, :string
      add :media_id, references(:files, on_delete: :nilify_all)

      timestamps(type: :utc_datetime)
    end

    create index(:pages, [:media_id])
  end
end
