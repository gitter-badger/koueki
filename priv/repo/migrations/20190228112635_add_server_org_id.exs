defmodule Koueki.Repo.Migrations.AddServerOrgId do
  use Ecto.Migration

  def change do
    alter table(:servers) do
      add :org_id, references(:orgs)
    end
  end
end
