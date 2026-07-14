defmodule SbCascade.Repo.Migrations.AddSuperUserToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :super_user, :boolean, default: false, null: false
    end
  end
end
