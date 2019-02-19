defmodule Koueki.Org do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset

  schema "orgs" do
    field :uuid, :binary_id
    field :name, :string
  end
end
