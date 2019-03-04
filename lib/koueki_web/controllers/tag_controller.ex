defmodule KouekiWeb.TagController do
  use KouekiWeb, :controller

  alias KouekiWeb.{
    ErrorStatus,
    TagView
  }

  alias Koueki.{
    Tag,
    Repo
  }

  def view(conn, %{"id" => id}, render_as \\ "tag.json") do
    with %Tag{} = tag <- Repo.get(Tag, id) do
      conn
      |> json(TagView.render(render_as, %{tag: tag}))
    else
      _ -> ErrorStatus.not_found(conn, "Tag #{id} not found")
    end
  end

  def create(conn, params, render_as \\ "tag.json") do
    tag = Tag.changeset(%Tag{}, params)

    if tag.valid? do
      with {:ok, tag} <- Repo.insert(tag) do
        conn
        |> put_status(201)
        |> json(TagView.render(render_as, %{tag: tag}))
      else
        {:error, tag} -> ErrorStatus.validation_error(conn, tag)
      end
    else
      ErrorStatus.validation_error(conn, tag)
    end
  end

  def search(conn, params) do
    {entries, page_count} = Tag.search(params)

    conn
    |> put_resp_header("X-Page-Count", to_string(page_count))
    |> json(TagView.render("tags.json", %{tags: entries}))
  end
end
