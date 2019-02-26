defmodule Koueki.Attribute do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset

  alias Koueki.{
    Attribute,
    Event,
    Tag,
    Repo
  }

  alias Ecto.{
    UUID,
    Changeset
  }

  schema "attributes" do
    field :uuid, UUID, autogenerate: true
    field :type, :string
    field :category, :string
    field :to_ids, :boolean, default: false
    field :distribution, :integer, default: 0
    field :comment, :string, default: ""
    field :deleted, :boolean, default: false
    field :data, :string
    field :value, :string

    timestamps()

    belongs_to :event, Event
    many_to_many :tags, Koueki.Tag, join_through: "attribute_tags"
  end

  def normalise_from_misp(%{} = params) do
    params
    |> Map.put("tags", Map.get(params, "Tag", []))
  end

  def normalise_from_misp(params) when is_list(params) do
    Enum.map(params, &normalise_from_misp/1)
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:type, :category, :to_ids, :distribution, :comment, :value, :event_id])
    |> unique_constraint(:attribute_is_unique,
      name: :attribute_is_unique_constraint,
      message: "Another attribute with a matching (value, type, category) exists on this event"
    )
    |> validate_required([:type, :value])
    |> validate_inclusion(:distribution, 0..5)
    |> validate_inclusion(:type, Attribute.Type.get_all("string"))
    |> validate_category()
    |> validate_to_ids()
    |> put_assoc(:tags, Tag.find_or_create(Map.get(params, "tags", [])))
  end

  defp validate_category(%Changeset{changes: %{type: type, category: category}} = changeset) do
    valid_categories =
      type
      |> Koueki.Attribute.Type.get()
      |> Map.get(:valid_for)

    if Enum.member?(valid_categories, category) do
      changeset
    else
      add_error(
        changeset,
        :category,
        "'#{category}' is not a valid category for '#{type}' - valid: #{
          Enum.join(valid_categories, ", ")
        }"
      )
    end
  end

  defp validate_category(%Changeset{changes: %{type: type}} = changeset) do
    # No category
    default_category =
      type
      |> Koueki.Attribute.Type.get()
      |> get_in([:defaults, :category])

    put_change(changeset, :category, default_category)
  end

  defp validate_category(%Changeset{changes: %{}} = changeset), do: changeset

  defp validate_to_ids(%Changeset{changes: %{to_ids: _}} = changeset), do: changeset

  defp validate_to_ids(%Changeset{changes: %{type: type}} = changeset) do
    default_to_ids =
      type
      |> Attribute.Type.get()
      |> get_in([:defaults, :to_ids])

    put_change(changeset, :to_ids, default_to_ids)
  end

  defp validate_to_ids(%Changeset{changes: %{}} = changeset), do: changeset

  def search(params) do
    page =
      from(attribute in Attribute,
        preload: [:tags]
      )
      |> limit_value(params)
      |> limit_type(params)
      |> limit_category(params)
      |> Repo.paginate(
        page: Map.get(params, "page", 0),
        page_size: Map.get(params, "limit", 20)
      )

    {page.entries, page.total_pages}
  end

  defp limit_value(query, %{"value" => value}) do
    from(attribute in query, where: ilike(attribute.value, ^value))
  end

  defp limit_value(query, _), do: query

  defp limit_type(query, %{"type" => type}) do
    from(attribute in query, where: attribute.type == ^type)
  end

  defp limit_type(query, _), do: query

  defp limit_category(query, %{"category" => category}) do
    from(attribute in query, where: attribute.category == ^category)
  end

  defp limit_category(query, _), do: query
end
