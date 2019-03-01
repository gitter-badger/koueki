defmodule Koueki.Server do
  use Ecto.Schema
  import Ecto.Changeset

  alias Koueki.{
    HTTPAdapters,
    Org,
    Server,
    Repo
  }

  alias Ecto.UUID

  schema "servers" do
    field :uuid, UUID, autogenerate: true
    field :url, :string
    field :apikey, :string
    field :name, :string
    field :last_sync, :utc_datetime
    field :push_enabled, :boolean, default: true
    field :pull_enabled, :boolean, default: true
    field :skip_ssl_validation, :boolean, default: false
    field :server_certificate, :string, default: nil
    field :client_certificate, :string, default: nil
    field :adapter, :string

    belongs_to :org, Koueki.Org
  end

  def changeset(struct, params) do
    struct
    |> cast(
      params,
      [
        :url,
        :apikey,
        :name,
        :org_id,
        :pull_enabled,
        :push_enabled,
        :skip_ssl_validation,
        :server_certificate,
        :client_certificate,
        :adapter,
        :last_sync
      ]
    )
    |> validate_required([:url, :apikey, :name, :org_id, :adapter])
    |> validate_inclusion(:adapter, ["koueki", "misp"])
    |> unique_constraint(:url)
    |> unique_constraint(:name)
  end
end
