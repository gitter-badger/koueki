defmodule Koueki.Org do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset

  schema "orgs" do
    field :uuid, Ecto.UUID, autogenerate: true
    field :name, :string
    field :description, :string
    field :created_by, :string
    field :local, :boolean, default: false
    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:name, :description, :local, :uuid])
    |> validate_required([:name])
    |> validate_length(:name, min: 1)
  end
end
