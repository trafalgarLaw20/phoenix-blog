defmodule Blogger.Repo.Migrations.AddCommentsTable do
  use Ecto.Migration

  def change do
    create table("comments") do
      add :content, :text
      add :user_id, references("users")
      add :article_id, references("articles", on_delete: :delete_all)

      timestamps()
    end

    create index("comments", [:user_id])
    create index("comments", [:article_id])
  end
end
