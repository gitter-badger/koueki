defmodule Koueki.Tag do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset

  alias Koueki.{
    Tag,
    Repo
  }

  schema "tags" do
    field :uuid, Ecto.UUID, autogenerate: true
    field :name, :string
    field :colour, :string, default: "#FFFFFF"

    many_to_many :events, Koueki.Event, join_through: "event_tags"
    many_to_many :attributes, Koueki.Attribute, join_through: "attribute_tags"
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:name, :colour])
    |> validate_required([:name])
    |> validate_format(:colour, ~r/#[0-9A-Fa-f]{6}/)
    |> validate_length(:name, min: 1)
    |> unique_constraint(:name)
  end

  defp find_by_id_or_name(params) do
    id = Map.get(params, "id", 0)
    name = Map.get(params, "name", "")

    Repo.one(
      from tag in Tag,
        where: tag.id == ^id or tag.name == ^name
    )
  end

  def find_or_create(%Tag{id: _} = tag), do: tag

  def find_or_create(%{} = params) do
    with %Tag{} = tag <- find_by_id_or_name(params) do
      tag
    else
      _ -> changeset(%Tag{}, params)
    end
  end

  def find_or_create(params) when is_list(params) do
    Enum.map(params, fn x -> find_or_create(x) end)
  end

  def search(params) do
    page =
      from(tag in Tag)
      |> restrict_name(params)
      |> restrict_uuid(params)
      |> Repo.paginate(
        page: Map.get(params, "page", 0),
        page_size: Map.get(params, "limit", 20)
      )

    {page.entries, page.total_pages}
  end

  defp restrict_name(query, %{"name" => name}) do
    from(tag in query, where: ilike(tag.name, ^name))
  end

  defp restrict_name(query, _), do: query

  defp restrict_uuid(query, %{"uuid" => uuid}) do
    from(tag in query, where: tag.uuid == ^uuid)
  end

  defp restrict_uuid(query, _), do: query
end
