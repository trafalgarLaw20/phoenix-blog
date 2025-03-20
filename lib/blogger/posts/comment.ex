defmodule Blogger.Posts.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  alias Blogger.Posts.Article
  alias Blogger.Users.User

  schema "comments" do
    field :content, :string

    belongs_to :article, Article
    belongs_to :user, User, foreign_key: :user_id

    timestamps()
  end

  def changeset(comment, attrs \\ %{}) do
    comment
    |> cast(attrs, [:content, :user_id, :article_id])
    |> validate_required([:content, :user_id, :article_id])
  end
end
