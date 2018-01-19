defmodule RepositoryTest do
  use ExUnit.Case
  import Ecto.Query

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "Get sum of visits for each post" do
    Repo.insert!(%Post{title: "title", body: "body", visits: 3})
    Repo.insert!(%Post{title: "title", body: "body", visits: 11})
    assert 14 == Repo.aggregate(Post, :sum, :visits)
  end

  test "Get average number of visits" do
    Repo.insert!(%Post{title: "title", body: "body", visits: 3})
    Repo.insert!(%Post{title: "title", body: "body", visits: 11})
    assert Decimal.compare(Decimal.new(7), Repo.aggregate(Post, :avg, :visits)) == Decimal.new(0)
  end

  test "Get all post's titles" do
    Repo.insert!(%Post{title: "title", body: "body", visits: 3})
    Repo.insert!(%Post{title: "title 1", body: "body", visits: 11})

    query = from p in Post,
      select: p.title

    assert ["title", "title 1"] == Repo.all(query)
  end
end
