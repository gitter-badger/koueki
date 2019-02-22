defmodule Koueki.Repo.Migrations.DropOrgc do
  use Ecto.Migration

  def change do
    drop(constraint(:events, "events_orgc_id_fkey"))
    drop table(:orgcs)

    alter table(:events) do
      modify :orgc_id, references(:orgs)
    end
  end
end
