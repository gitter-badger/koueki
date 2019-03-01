defmodule Koueki.Repo.Migrations.AddSharinggroupBelongsToOrg do
  use Ecto.Migration

  def change do
    alter table(:sharing_groups) do
      add :org_id, references(:orgs)
    end
  end
end
