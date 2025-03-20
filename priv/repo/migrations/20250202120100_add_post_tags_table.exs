defmodule Blogger.Repo.Migrations.AddPostTagsTable do
  use Ecto.Migration

  def change do
    create table("post_tags") do
      add :post_id, references("articles", on_delete: :delete_all)
      add :tag_id, references("tags", on_delete: :delete_all)

      timestamps()
    end
  end
end
