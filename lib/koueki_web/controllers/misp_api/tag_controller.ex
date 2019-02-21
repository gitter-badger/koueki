defmodule KouekiWeb.MISPAPI.TagController do
  use KouekiWeb, :controller

  alias Koueki.{
    Tag,
    Repo
  }

  alias KouekiWeb.{
    MISPAPI,
    TagController
  }

  def view(conn, params) do
    TagController.view(conn, params)
  end

  def create(conn, %{"Tag" => params}) do
    TagController.create(conn, params, "tag.wrapped.json")
  end

  def create(conn, params) do
    create(conn, %{"Tag" => params})
  end
end
