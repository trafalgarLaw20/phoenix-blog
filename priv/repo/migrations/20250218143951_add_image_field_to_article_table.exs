defmodule Blogger.Repo.Migrations.AddImageFieldToArticleTable do
  use Ecto.Migration

  def change do
    alter table("articles") do
      add :image, :string
    end
  end
end
