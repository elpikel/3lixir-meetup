defmodule Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :title, :string
    field :body, :string
    field :visits, :integer

    belongs_to :user, User
    has_many :comments, Comment

    many_to_many :categories, Category, join_through: "posts_categories"

    timestamps()
  end

  def changeset(post, params \\ %{}) do
    post
    |> cast(params, [:title, :body, :integer])
    |> validate_required([:title, :body, :integer])
  end
end
