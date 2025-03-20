defmodule BloggerWeb.PageController do
  use BloggerWeb, :controller

  alias Blogger.Post
  alias Blogger.Posts.{Article, Comment}

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    articles = Post.list_articles()
    render(conn, :home, articles: articles)
  end

  def new(conn, _params) do
    conn
    |> assign(:changeset, Post.change_article(%Article{}))
    |> render(:new)
  end

  def show(conn, %{"id" => id}) do
    article = Post.get_article!(id)
    changeset = Post.change_comment(%Comment{})

    conn
    |> assign(:article, article)
    |> assign(:changeset, changeset)
    |> render(:show)

    # render(conn, :show, article: article, changeset: changeset)
  end

  def create(conn, %{"article" => article_params}) do
    if Pow.Plug.current_user(conn) do
      post_params_with_user =
        article_params
        |> Map.put("user_id", Pow.Plug.current_user(conn).id)

      IO.inspect(post_params_with_user)

      case Post.create_article(post_params_with_user) do
        {:ok, article} ->
          File.cp(
            article_params["upload"].path,
            "priv/static/uploads/#{article.image}"
          )

          conn
          |> put_flash(:info, "Article created successfully.")
          |> redirect(to: ~p"/articles/#{article}")

        {:error, changeset} ->
          conn
          |> assign(:changeset, changeset)
          |> render(:new)
      end
    end
  end

  def edit(conn, %{"id" => id}) do
    article = Post.get_article!(id)

    conn
    |> assign(:changeset, Post.change_article(%Article{}))
    |> assign(:article, article)
    |> render(:edit)
  end

  def update(conn, %{"id" => id, "article" => article_params}) do
    found_article = Post.get_article!(id)

    IO.inspect(article_params)

    case Post.update_article(found_article, article_params) do
      {:ok, article} ->
        if article_params["upload"] do
          File.cp(
            article_params["upload"].path,
            "priv/static/uploads/#{article.image}"
          )

          File.rm(Path.expand("priv/static/uploads/#{found_article.image}"))
        end

        conn
        |> put_flash(:info, "Article updated successfully.")
        |> redirect(to: ~p"/articles/#{article}")

      {:error, changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> render(:edit)
    end
  end

  def delete(conn, %{"id" => id}) do
    article = Post.get_article!(id)

    case Post.delete_article(article) do
      {:ok, article} ->
        File.rm(Path.expand("priv/static/uploads/#{article.image}"))

        conn
        |> put_flash(:info, "Article deleted successfully.")
        |> redirect(to: "/")

      _ ->
        :error
    end
  end
end
