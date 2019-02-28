defmodule Koueki.Repo.Migrations.AddServerLastSyncDefaultToEpoch do
  use Ecto.Migration

  def change do
    alter table(:servers) do
      modify :last_sync, :utc_datetime, default: "1970-01-01 00:00:00"
    end
  end
end
