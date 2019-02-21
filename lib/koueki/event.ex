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
    field :distribution, :integer, default: 0

    timestamps()

    belongs_to :org, Koueki.Org
    belongs_to :orgc, Koueki.OrgC

    many_to_many :tags, Koueki.Tag, join_through: "event_tags"

    has_many :attributes, Koueki.Attribute
  end

  def load_assoc(%Event{} = event) do
    Repo.one(
      from event in Event,
      where: event.id == ^event.id,
      left_join: attributes in assoc(event, :attributes),
      left_join: attr_tags in assoc(attributes, :tags),
      preload: [:tags, attributes: {attributes, tags: attr_tags}]
    )
  end

  def changeset(params) do
    %Event{}
    |> cast(params, [:published, :info, :threat_level_id, :analysis, :date, :distribution])
    |> cast_assoc(:attributes, with: &Attribute.changeset/2)
    |> put_assoc(:tags, Tag.find_or_create(Map.get(params, "tags", [])))
    |> validate_required([:info])
    |> validate_inclusion(:threat_level_id, 1..4)
    |> validate_inclusion(:analysis, 0..2)
    |> validate_inclusion(:distribution, 0..4)
    |> validate_date()
  end

  defp validate_date(%Changeset{changes: %{date: date}} = changeset) do
    changeset
  end

  defp validate_date(%Changeset{} = changeset) do
    changeset
    |> put_change(:date, Timex.today)
  end
end
