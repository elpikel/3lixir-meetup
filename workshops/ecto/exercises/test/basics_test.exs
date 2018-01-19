defmodule BasicsTest do
  use ExUnit.Case

  test "should be able to fetch and delete posts" do
    Repo.delete_all(Post)
    post = %Post{title: "title", body: "content"}
    Repo.insert(post)
    posts = Repo.all(Post)

    assert 1 == Enum.count(posts)
  end
end
