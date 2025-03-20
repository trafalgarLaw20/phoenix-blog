defmodule Blogger.Repo.Migrations.AddArticlesTable do
  use Ecto.Migration

  def change do
    create table("articles") do
      add :title, :string
      add :content, :text
      add :category_id, references("categories", on_delete: :delete_all)
      add :user_id, references("users")

      timestamps()
    end

    create index("articles", [:category_id])
    create index("articles", [:user_id])
  end
end
