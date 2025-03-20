defmodule Blogger.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  alias Blogger.Posts.Article
  alias Blogger.Posts.Comment

  schema "users" do
    pow_user_fields()
    has_many :articles, Article
    has_many :comments, Comment

    timestamps()
  end
end
