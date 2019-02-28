defmodule Koueki.Repo.Migrations.AddServerTable do
  use Ecto.Migration

  def change do
    create table(:servers) do
      add :uuid, :uuid, null: false
      add :url, :text, null: false
      add :apikey, :string, null: false
      add :name, :string, null: false
      add :last_sync, :utc_datetime
      add :push_enabled, :boolean, default: true
      add :pull_enabled, :boolean, default: true
      add :skip_ssl_validation, :boolean, default: false
      add :server_certificate, :text, default: ""
      add :client_certificate, :string, default: ""
    end

    create unique_index(:servers, [:uuid, :name])
    
  end
end
