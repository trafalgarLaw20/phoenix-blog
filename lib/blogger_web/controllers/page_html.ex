defmodule BloggerWeb.PageHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use BloggerWeb, :html

  embed_templates "page_html/*"

  def category_opts(changeset) do
    existing_ids =
      changeset |> Ecto.Changeset.get_change(:categories, []) |> Enum.map(& &1.data.id)

    for cat <- Blogger.Post.list_categories() do
      [key: cat.name, value: cat.id, selected: cat.id in existing_ids]
    end
  end
end
