defmodule Repo.Migrations.CreatePostsCategories do
  use Ecto.Migration

  def change do
    create table(:posts_categories) do
      add :category_id, references(:categories)
      add :post_id, references(:posts)
    end

    create unique_index(:posts_categories, [:category_id, :post_id])
  end
end
