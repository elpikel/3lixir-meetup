defmodule Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :body, :string

    belongs_to :user, User
    belongs_to :post, Post

    timestamps()
  end

  def changeset(comment, params \\ %{}) do
    comment
    |> cast(params, [:body])
    |> validate_required([:body])
  end
end
