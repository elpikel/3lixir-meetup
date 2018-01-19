defmodule Repo.Migrations.AddCategoryTable do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string

      timestamps()
    end
  end
end
