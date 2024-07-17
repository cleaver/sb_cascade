defmodule SbCascade.Repo.Migrations.CreateComics do
  use Ecto.Migration

  def change do
    create table(:comics) do
      add :title, :string
      add :body, :text
      add :slug, :string
      add :published, :boolean, default: false, null: false
      add :post_date, :date
      add :meta_description, :string
      add :image_alt_text, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:comics, [:user_id])
  end
end
