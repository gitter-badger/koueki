defmodule Koueki.Server do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.UUID

  schema "servers" do
    field :uuid, UUID, autogenerate: true
    field :url, :string
    field :apikey, :string
    field :name, :string
    field :last_sync, :utc_datetime, default: ~N[1970-01-01 00:00:00]
    field :push_enabled, :boolean, default: true
    field :pull_enabled, :boolean, default: true
    field :skip_ssl_validation, :boolean, default: false
    field :server_certificate, :string
    field :client_certificate, :string
    field :adapter, :string

    belongs_to :org, Koueki.Org
  end

  def changeset(struct, params) do
    struct
    |> cast(params,
      [:url, :apikey, :name, :org_id, :pull_enabled, :push_enabled, :skip_ssl_validation,
       :server_certificate, :client_certificate
      ])
    |> validate_required([:url, :apikey, :name, :org_id])
    |> validate_inclusion(:adapter, ["koueki", "misp"])
  end
end  
