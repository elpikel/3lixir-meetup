defmodule BasicsTest do
  use ExUnit.Case

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "should be able to fetch and delete posts" do
    post = %Post{title: "title", body: "content"}
    Repo.insert(post)
    posts = Repo.all(Post)

    assert 1 == Enum.count(posts)
  end
end
