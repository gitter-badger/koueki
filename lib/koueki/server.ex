defmodule Koueki.Server do
  use Ecto.Schema
  import Ecto.Changeset

  alias Koueki.{
    HTTP,
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
       :server_certificate, :client_certificate, :adapter,
      ])
    |> validate_org()
    |> validate_required([:url, :apikey, :name, :org_id, :adapter])
    |> validate_inclusion(:adapter, ["koueki", "misp"])
  end

  defp validate_org(%Ecto.Changeset{changes: %{org_id: org_id}} = changeset) do
    with %Org{} = org <- Repo.get(Org, org_id) do
      changeset
    else
      nil ->
        add_error(changeset, :org_id, "Org #{org_id} not found")
    end
  end

  def maybe_get_remote_org(%{url: url, adapter: "koueki"} = server) do
    # If we're using the koueki adapter we can retrieve the remote org at will!
    owner_url =
      url
      |> URI.merge("/instance/owner")
      |> URI.to_string()

    case HTTPoison.get(owner_url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, decoded} = Jason.decode(body)
      {:ok, %HTTPoison.Response{status_code: 403}} ->
        {:error, :permission_denied}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def maybe_get_remote_org(%{adapter: "misp"} = server) do
    # If we're using the MISP one it's a bit harder
    case HTTP.Adapters.MISP.request(:get, server, "/organisations/index") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, decoded} = Jason.decode(body)
        organisations = 
          decoded
          |> Enum.map(fn x -> x["Organisation"] end)
          |> Enum.map(fn org_json ->
            org_json
            |> Org.get_or_create()
            |> case do
              %Org{} = org -> org
              %Ecto.Changeset{} = org -> Repo.insert(org)
            end
          end)
        {:ok, :require_manual}
      {:ok, %HTTPoison.Response{status_code: 403}} ->
        {:error, :permission_denied}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end  
