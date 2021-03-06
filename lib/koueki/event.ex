defmodule Koueki.Event do
  use Ecto.Schema
  use Timex
  import Ecto.Query
  import Ecto.Changeset

  alias Koueki.{
    Event,
    Attribute,
    Tag,
    Repo,
    Org,
    User,
    SharingGroup
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
    belongs_to :sharing_group, Koueki.SharingGroup
    belongs_to :user, Koueki.User
    has_many :attributes, Koueki.Attribute, on_replace: :delete
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
    |> Map.delete("Attribute")
    |> Map.put("tags", Map.get(params, "Tag", []))
    |> Map.delete("Tag")
    |> Map.put("org", Map.get(params, "Orgc", %{}))
    |> Map.delete("Org")
    |> Map.delete("Orgc")
    |> maybe_normalise_sharing_groups()
  end

  defp maybe_normalise_sharing_groups(%{"SharingGroup" => group} = params) do
    params
    |> Map.put("sharing_group", SharingGroup.normalise_from_misp(group))
    |> Map.delete("SharingGroup")
  end

  defp maybe_normalise_sharing_groups(params), do: params

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
      :uuid
    ])
    |> cast_assoc(:attributes, with: &Attribute.changeset/2)
    |> put_assoc(:tags, Tag.find_or_create(Map.get(params, "tags", [])))
    |> put_assoc(:org, Org.find_or_create(Map.get(params, "org")))
    |> maybe_add_sharing_group(params)
    |> validate()
  end

  def add_tags_changeset(struct, %{tags: tags}) do
    struct
    |> cast(%{}, [])
    |> put_assoc(:tags, struct.tags ++ Tag.find_or_create(tags))
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

  def resolve_inbound_attributes(%{"attributes" => remote_attrs} = event_params, %Event{
        attributes: local_attrs
      }) do
    event_params
    |> Map.put("attributes", Attribute.resolve_from_inbound_event(local_attrs, remote_attrs))
  end

  def resolve_inbound_attributes(event_params, nil) do
    # Local event does not exist
    resolve_inbound_attributes(event_params, %Event{attributes: []})
  end

  @doc """
  Is a given event visible for a user?
  """
  def visible?(%Event{} = event, %User{} = user) do
    case event.distribution do
      0 ->
        # This organisation only
        event.org_id == user.org_id

      1 ->
        # This community only (i.e on this instance)
        true

      2 ->
        # Connected communities
        # If you're on this instance you're connected to our community, 常考
        true

      3 ->
        # All communities (duh)
        true

      4 ->
        # Member of sharing group
        # FUGG
        # FIXME when I've implemented this
        true
    end
  end

  defp maybe_add_sharing_group(%Changeset{} = changeset, %{"sharing_group" => sharing_group}) do
    changeset
    |> put_assoc(:sharing_group, SharingGroup.find_or_create(sharing_group))
  end

  defp maybe_add_sharing_group(%Changeset{} = changeset, _) do
    changeset
  end
end
