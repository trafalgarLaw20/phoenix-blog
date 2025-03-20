defmodule BloggerWeb.CommentController do
  use BloggerWeb, :controller
  alias Blogger.Post

  def create(conn, %{"id" => id, "comment" => comment_params}) do
    comment_with_user_and_article =
      comment_params
      |> Map.put("user_id", Pow.Plug.current_user(conn).id)
      |> Map.put("article_id", id)

    IO.inspect(comment_with_user_and_article)

    case Post.create_comment(comment_with_user_and_article) do
      {:ok, _comment} ->
        conn
        |> put_flash(:info, "Comment add successfully.")
        |> redirect(to: "/articles/#{id}")

      {:error, _changeset} ->
        conn
        |> redirect(to: "/articles/#{id}")
    end
  end

  def delete(conn, %{"comment_id" => comment_id, "article_id" => id}) do
    comment = Post.get_comment(comment_id)

    if comment.user_id == Pow.Plug.current_user(conn).id do
      {:ok, _comment} = Post.delete_comment(comment)

      conn
      |> put_flash(:info, "Comment deleted successfully.")
      |> redirect(to: "/articles/#{id}")
    end
  end
end
