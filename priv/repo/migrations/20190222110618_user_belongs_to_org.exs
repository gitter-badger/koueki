defmodule Koueki.Repo.Migrations.UserBelongsToOrg do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :org_id, references(:orgs)
    end
  end
end
