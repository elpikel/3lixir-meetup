defmodule MigrationTest do
  use ExUnit.Case

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "post has many categories" do
    category = Repo.insert!(%Category{name: "name"})
    post = Repo.insert!(%Post{title: "title", body: "body", categories: []})
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:categories, [category])
    |> Repo.update!()

    post_with_categories = Repo.get(Post, post.id) |> Repo.preload(:categories)
    assert 1 == Enum.count(post_with_categories.categories)
  end

  test "category has many posts" do
    post = Repo.insert!(%Post{title: "title", body: "body"})
    category = Repo.insert!(%Category{name: "name", posts: []})
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:posts, [post])
    |> Repo.update!()

    category_with_post = Repo.get(Category, category.id) |> Repo.preload(:posts)
    assert 1 == Enum.count(category_with_post.posts)
  end

  test "user has many posts" do
    user = %User{name: "user"}
    user = Repo.insert!(user)
    post = Ecto.build_assoc(user, :posts, %{title: "title", body: "content"})
    Repo.insert(post)

    user_with_posts = Repo.get(User, user.id) |> Repo.preload(:posts)

    assert user_with_posts.name == "user"
    assert 1 = Enum.count(user_with_posts.posts)
  end

  test "post has many comments" do
    post = %Post{title: "title", body: "body"}
    post = Repo.insert!(post)
    comment = Ecto.build_assoc(post, :comments, %{body: "body"})
    Repo.insert(comment)

    post_with_comments = Repo.get(Post, post.id) |> Repo.preload(:comments)

    assert post_with_comments.title == "title"
    assert 1 = Enum.count(post_with_comments.comments)
  end

  test "user has many comments" do
    user = %User{name: "user"}
    user = Repo.insert!(user)
    comment = Ecto.build_assoc(user, :comments, %{body: "content"})
    Repo.insert(comment)

    user_with_comments = Repo.get(User, user.id) |> Repo.preload(:comments)

    assert user_with_comments.name == "user"
    assert 1 = Enum.count(user_with_comments.comments)
  end
end
