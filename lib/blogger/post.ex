defmodule Blogger.Post do
  alias Blogger.Repo
  alias Blogger.Post

  alias Blogger.Posts.Article
  alias Blogger.Posts.Category
  alias Blogger.Posts.Comment

  def list_articles do
    Repo.all(Article) |> Repo.preload(:comments)
  end

  def get_article!(id) do
    Repo.get!(Article, id) |> Repo.preload(:comments)
  end

  def create_article(attrs \\ %{}) do
    %Article{}
    |> Post.change_article(attrs)
    |> Repo.insert()
  end

  def update_article(article, attrs \\ %{}) do
    article
    |> Post.change_article(attrs)
    |> Repo.update()
  end

  def delete_article(article) do
    article
    |> Repo.delete()
  end

  def change_article(%Article{} = article, attrs \\ %{}) do
    Article.changeset(article, attrs)
  end

  # Category handling

  def list_categories do
    Repo.all(Category)
  end

  # Comment handling

  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end

  def get_comment(id) do
    Repo.get!(Comment, id)
  end

  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Post.change_comment(attrs)
    |> Repo.insert()
  end

  def delete_comment(comment) do
    comment
    |> Repo.delete()
  end
end
