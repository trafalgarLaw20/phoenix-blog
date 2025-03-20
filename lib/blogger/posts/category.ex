defmodule Blogger.Posts.Category do
  use Ecto.Schema
  import Ecto.Changeset

  alias Blogger.Posts.Article

  schema "categories" do
    field :name, :string
    field :description, :string

    has_many :articles, Article
    timestamps()
  end

  def changeset(category, attrs \\ %{}) do
    category
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
