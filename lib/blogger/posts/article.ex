defmodule Blogger.Posts.Article do
  use Ecto.Schema
  import Ecto.Changeset

  alias Blogger.Posts.Category
  alias Blogger.Users.User
  alias Blogger.Posts.Comment

  schema "articles" do
    field :title, :string
    field :content, :string
    field :image, :string
    field :upload, :map, virtual: true

    belongs_to :user, User
    belongs_to :category, Category

    has_many :comments, Comment

    timestamps()
  end

  def changeset(article, attrs \\ %{}) do
    article
    |> cast(attrs, [:title, :content, :user_id, :category_id, :image, :upload])
    |> validate_required([:title, :content, :user_id, :category_id])
    |> validate_upload(:upload)
  end

  defp validate_upload(changeset, field) do
    case get_change(changeset, field) do
      %Plug.Upload{} = upload ->
        changeset
        |> validate_content_type(upload)
        |> validate_file_size(upload)
        |> set_image(upload)

      nil ->
        changeset

      _ ->
        add_error(changeset, field, "Invalid file type")
    end
  end

  defp validate_content_type(changeset, %Plug.Upload{content_type: content_type}) do
    allowed_types = ["image/jpeg", "image/png", "image/gif", "image/webp"]

    if content_type in allowed_types do
      changeset
    else
      add_error(changeset, :upload, "Invalid file type")
    end
  end

  defp validate_file_size(changeset, %Plug.Upload{path: path}) do
    max_size = 10 * 1024 * 1024

    case File.stat(path) do
      {:ok, %{size: size}} when size <= max_size ->
        changeset

      {:ok, _} ->
        add_error(changeset, :upload, "File size exceeds limit")

      _ ->
        add_error(changeset, :upload, "Error validate file")
    end
  end

  defp set_image(changeset, %Plug.Upload{filename: filename}) do
    unique_name = "#{DateTime.utc_now() |> DateTime.to_unix()}_#{filename}"
    put_change(changeset, :image, unique_name)
  end
end
