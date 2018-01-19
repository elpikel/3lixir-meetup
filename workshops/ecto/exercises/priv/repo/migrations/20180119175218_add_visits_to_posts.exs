defmodule Repo.Migrations.AddVisitsToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :visits, :integer
    end
  end
end
