defmodule SbCascade.Repo.Migrations.AlterFilesRemoveHw do
  use Ecto.Migration

  def change do
    alter table(:files) do
      remove :height, :integer
      remove :width, :integer
    end
  end
end
