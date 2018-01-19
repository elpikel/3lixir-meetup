defmodule Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :name, :string

    many_to_many :posts, Post, join_through: "posts_categories"

    timestamps()
  end

  def changeset(category, params \\ %{}) do
    category
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
