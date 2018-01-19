# Query

Queries are used to retrieve and manipulate data from a repository (see Ecto.Repo). Ecto queries come in two flavors: keyword-based and macro-based. Most examples will use the keyword-based syntax, the macro one will be explored in later sections.

```elixir
# Imports only from/2 of Ecto.Query
import Ecto.Query, only: [from: 2]

# Create a query
query = from u in "users",
          where: u.age > 18,
          select: u.name

# Send the query to the repository
Repo.all(query)
```

External values and Elixir expressions can be injected into a query expression with ^:
```elixir
def with_minimum(age, height_ft) do
  from u in "users",
    where: u.age > ^age and u.height > ^(height_ft * 3.28),
    select: u.name
end

with_minimum(18, 5.0)
```

When interpolating values, you may want to explicitly tell Ecto what is the expected type of the value being interpolated:
```elixir
age = "18"
Repo.all(from u in "users",
          where: u.age > type(^age, :integer),
          select: u.name)
```
To avoid the repetition of always specifying the types, you may define an Ecto.Schema. In such cases, Ecto will analyze your queries and automatically cast the interpolated “age” when compared to the u.age field, as long as the age field is defined with type :integer in your schema.

Ecto queries are composable. For example, the query above can actually be defined in two parts:

```elixir
# Create a query
query = from u in User, where: u.age > 18

# Extend the query
query = from u in query, select: u.name
```

When using joins, the bindings should be matched in the order they are specified:

```elixir
# Create a query
query = from p in Post,
          join: c in Comment, where: c.post_id == p.id

# Extend the query
query = from [p, c] in query,
          select: {p.title, c.body}
```

Bindingless operations
```elixir
from Post,
  where: [category: "fresh and new"],
  order_by: [desc: :published_at],
  select: [:id, :title, :body]
```

Fragments

```elixir
from p in Post,
  where: is_nil(p.published_at) and
         fragment("lower(?)", p.title) == ^title
```

Due to the prevalence of the pipe operator in Elixir, Ecto also supports a pipe-based syntax:
```elixir
"users"
|> where([u], u.age > 18)
|> select([u], u.name)
```

Do all exercises using dsl and pipe:
1.Select distinct posts (based on category)
2.Compose dynamic where based on user input
3.Get first post
4.Select only body and title from post
5.Implement pagination function
6.Group posts by category
7.Get posts that have more than 3 comments
8.Join posts with users/comments using :inner, :left, :right, :cross, :full, :inner_lateral or :left_lateral
9.Join posts with user/comments using assoc
10.Select post with comments count using Fragments
11.Select posts within given month
12.Get last post.
13.Try to combine queries.
14.Get posts ordered_by pubication date and comments count.
15.Preload comments in posts
4.Select only body and title from post
5.Implement pagination function
6.Group posts by category
7.Get posts that have more than 3 comments
8.Join posts with users/comments using :inner, :left, :right, :cross, :full, :inner_lateral or :left_lateral
9.Join posts with user/comments using assoc
10.Select post with comments count using Fragments
11.Select posts within given month
12.Get last post.
13.Try to combine queries.
14.Get posts ordered_by pubication date and comments count.
15.Preload comments in posts
16.Select only body from posts.
17.Update all posts publication date.
