defmodule Koueki.SharingGroup do
  @moduledoc """
  A group of organisations, to whom an organisation has given view
  of certain events

  Koueki will NOT implement sharing group creation, however we must
  honour externally-created viewing restrictions so as to not piss
  off literally everyone
  """

  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Koueki.{
    Repo,
    Org,
    SharingGroup
  }

  alias Ecto.UUID

  schema "sharing_groups" do
    field :name, :string
    field :releasability, :string
    field :description, :string
    field :uuid, UUID
    field :active, :boolean

    belongs_to :org, Koueki.Org
    many_to_many :member_orgs, Koueki.Org, join_through: "sharing_group_orgs"
  end

  def normalise_from_misp(%{} = params) do
    params
    |> Map.put("org", Map.get(params, "Organisation"))
    |> Map.delete("Organisation")
    |> Map.put("member_orgs",
        params
        |> Map.get("SharingGroupOrg", [])
        |> Enum.map(fn x -> x["Organisation"] end)
      )
    |> Map.delete("SharingGroupOrg")
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:name, :uuid, :releasability, :description, :active])
    |> put_assoc(:org, Org.find_or_create(Map.get(params, "org")))
    |> put_assoc(:member_orgs, Org.find_or_create(Map.get(params, "member_orgs")))
  end

  def find_or_create(%{"uuid" => uuid} = params) do
    with %SharingGroup{} = sharing_group <- Repo.one(
      from group in SharingGroup, where: group.uuid == ^uuid,
      preload: [:member_orgs, :org]) do
      sharing_group
      |> changeset(params)
    else
      nil ->
        %SharingGroup{}
        |> changeset(params)
    end
  end
end
