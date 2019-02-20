defmodule Koueki.Org do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset

  schema "orgs" do
    field :uuid, Ecto.UUID, autogenerate: true
    field :name, :string
  end
end
