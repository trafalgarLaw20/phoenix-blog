# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Blogger.Repo.insert!(%Blogger.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

list_categories = [
  %{
    name: "Elixir",
    description: "Elixir programming language."
  },
  %{
    name: "Phoenix",
    description: "Phoenix web framework."
  },
  %{
    name: "Ecto",
    description: "Ecto database wrapper."
  },
  %{
    name: "Pow",
    description: "Pow authentication system."
  }
]

for category <- list_categories do
  changeset = Blogger.Posts.Category.changeset(%Blogger.Posts.Category{}, category)
  {:ok, _} = Blogger.Repo.insert(changeset)
end
