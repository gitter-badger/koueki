defmodule Koueki.Event do
  use Ecto.Schema
  use Timex
  import Ecto.Query
  import Ecto.Changeset

  alias Koueki.{
    Event,
    Attribute,
    Tag,
    Repo
  }

  alias Ecto.Changeset
  alias Ecto.UUID

  schema "events" do
    field :uuid, UUID, autogenerate: true
    field :published, :boolean, default: false
    field :info, :string
    field :threat_level_id, :integer, default: 4
    field :analysis, :integer, default: 0
    field :date, :date
    field :publish_timestamp, :utc_datetime
    field :attribute_count, :integer
    field :distribution, :integer, default: 3

    timestamps()

    belongs_to :org, Koueki.Org
    has_many :attributes, Koueki.Attribute
    many_to_many :tags, Koueki.Tag, join_through: "event_tags"
  end

  @doc """
  Rename any MISP parameters to new not-entirely-retarded ones
  """
  def normalise_from_misp(%{} = params) do
    params
    |> Map.put(
      "attributes",
      params
      |> Map.get("Attribute", [])
      |> Attribute.normalise_from_misp()
    )
    |> Map.put("tags", Map.get(params, "Tag", []))
  end

  def get_with_preload(id, preload \\ []) do
    Repo.one(
      from event in Event,
        where: event.id == ^id,
        preload: ^preload
    )
  end

  def load_assoc(%Event{} = event) do
    Repo.one(
      from event in Event,
        where: event.id == ^event.id,
        left_join: attributes in assoc(event, :attributes),
        left_join: attr_tags in assoc(attributes, :tags),
        preload: [:org, :tags, attributes: {attributes, tags: attr_tags}]
    )
  end

  defp validate(changeset) do
    changeset
    |> validate_required([:info])
    |> validate_inclusion(:threat_level_id, 1..4)
    |> validate_inclusion(:analysis, 0..2)
    |> validate_inclusion(:distribution, 0..4)
    |> validate_date()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [
      :published,
      :info,
      :threat_level_id,
      :analysis,
      :date,
      :distribution,
      :org_id
    ])
    |> cast_assoc(:attributes, with: &Attribute.changeset/2)
    |> put_assoc(:tags, Tag.find_or_create(Map.get(params, "tags", [])))
    |> validate()
  end

  def edit_changeset(struct, params) do
    struct
    |> cast(params, [
      :published,
      :info,
      :threat_level_id,
      :analysis,
      :date,
      :distribution,
      :org_id
    ])
    |> validate()
  end

  defp validate_date(%Changeset{changes: %{date: _}} = changeset) do
    changeset
  end

  defp validate_date(%Changeset{} = changeset) do
    changeset
    |> put_change(:date, Timex.today())
  end

  def search(params) do
    page =
      from(event in Event,
        left_join: attributes in assoc(event, :attributes),
        left_join: attr_tags in assoc(attributes, :tags),
        preload: [:org, :tags, attributes: {attributes, tags: attr_tags}]
      )
      |> limit_id(params)
      |> limit_info(params)
      |> order_by(desc: :id)
      |> Repo.paginate(
        page: Map.get(params, "page", 0),
        page_size: Map.get(params, "limit", 20)
      )

    {page.entries, page.total_pages}
  end

  defp limit_id(query, %{"id" => id}) do
    from(event in query, where: event.id == ^id)
  end

  defp limit_id(query, _), do: query

  defp limit_info(query, %{"info" => info}) do
    from(event in query, where: like(event.info, ^info))
  end

  defp limit_info(query, _), do: query
end
