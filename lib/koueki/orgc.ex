defmodule Koueki.OrgC do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset
  alias Ecto.UUID

  schema "orgcs" do
    field :uuid, UUID, autogenerate: true
    field :name, :string
  end
end
