defmodule Koueki.OrgC do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset

  schema "orgcs" do
    field :uuid, :binary_id
    field :name, :string
  end
end
