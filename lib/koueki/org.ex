defmodule Koueki.Org do
  use Ecto.Schema
  import Ecto.Changeset

  alias Koueki.{
    Org,
    Repo,
    SharingGroup
  }

  schema "orgs" do
    field :uuid, Ecto.UUID, autogenerate: true
    field :name, :string
    field :description, :string
    field :created_by, :string
    field :local, :boolean, default: false

    many_to_many :sharing_groups, SharingGroup, join_through: "sharing_group_orgs"

    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:name, :description, :local, :uuid])
    |> validate_required([:name])
    |> validate_length(:name, min: 1)
    |> unique_constraint(:uuid)
    |> unique_constraint(:name)
  end

  def find_or_create(%Org{} = org), do: org

  def find_or_create(%{"uuid" => uuid} = params) do
    with %Org{} = org <- Repo.get_by(Org, uuid: uuid) do
      org
    else
      nil ->
        changeset(%Org{}, params)
    end
  end

  def find_or_create(%{} = params) do
    changeset(%Org{}, params)
  end

  def find_or_create(params) when is_list(params) do
    Enum.map(params, &find_or_create/1)
  end
end
