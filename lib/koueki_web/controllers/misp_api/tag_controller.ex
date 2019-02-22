defmodule KouekiWeb.MISPAPI.TagController do
  use KouekiWeb, :controller
  import Ecto.Query
  import Ecto.Changeset

  alias Ecto.Changeset

  alias Koueki.{
    Tag,
    Event,
    Attribute,
    Repo
  }

  alias KouekiWeb.{
    MISPAPI,
    TagController,
    Status,
    EventView,
    AttributeView
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

  defp find_object_by_uuid(uuid) do
    found = 
      Repo.one(
        from event in Event, 
        left_join: attribute in Attribute,
        where: attribute.uuid == ^uuid or event.uuid == ^uuid,
        preload: [:tags]
      )

    if is_nil(found) do
      {:not_found, uuid}
    else
      {:found, found}
    end
  end

  defp tag_attached(conn, object) do
    just_attached = List.last(object.tags)
    conn
    |> json(%{message: "Tag #{just_attached.name}(#{just_attached.id}) attached succesfully"})
  end

  @doc """
  Accept a "tag" parameter, then:
    - If the tag is an integer (or parsable as one), rely ONLY on that ID and fail if not found
    - If the tag is a string, matching the name of an existing tag, use existing
    - If the tag is a string, not matching any existing, create and attach it
  The difficulty in this function comes with the variability, hence I've split it up
  for your sanity
  """
  def attach(conn, %{"uuid" => uuid, "tag" => tag_id}) when is_integer(tag_id) do
    with {:found, object} <- find_object_by_uuid(uuid),
         %Tag{} = tag <- Repo.get(Tag, tag_id) do
      # We have both a valid tag and an object
      # Easy peasy
      new_tags = object.tags ++ [tag]
      changeset = case object do
        %Event{} -> Event.changeset(object, %{"tags" => new_tags})
        %Attribute{} -> Attribute.changeset(object, %{"tags" => new_tags})
      end
      {:ok, object } = Repo.update(changeset)
      tag_attached(conn, object)      
    else
      {:not_found, uuid} -> Status.not_found("Object #{uuid} not found")
      nil -> Status.not_found(conn, "Tag #{tag_id} not found")
    end 
  end

  def attach(conn, %{"uuid" => uuid, "tag" => tag}) when is_binary(tag) do
    with {integer_tag, ""} <- Integer.parse(tag) do
      # The tag is parsable as an integer, use that
      attach(conn, %{"uuid" => uuid, "tag" => integer_tag})
    else
      _ ->
        # Tag must be a string
        # Can just be thrown to find_or_create
        tag = Tag.find_or_create(%{"name" => tag})

        db_tag = case tag do
          %Tag{} -> tag
          %Changeset{} -> 
            {:ok, inserted} = Repo.insert(tag)
            inserted
        end
        attach(conn, %{"uuid" => uuid, "tag" => db_tag.id})
    end
  end
end
