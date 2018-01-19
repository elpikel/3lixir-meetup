defmodule Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :title, :string
    field :body, :string

    timestamps()
  end

  def changeset(post, params \\ %{}) do
    post
    |> cast(params, [:title, :body])
    |> validate_required([:title, :body])
  end
end
