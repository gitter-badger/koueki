defmodule Koueki.Repo.Migrations.ModifyReferences do
  use Ecto.Migration

  def change do
    drop constraint(:events, "events_org_id_fkey")
    drop constraint(:events, "events_sharing_group_id_fkey")

    alter table(:events) do
      modify :org_id, references(:orgs, on_delete: :delete_all)
      modify :sharing_group_id, references(:sharing_groups, on_delete: :nilify_all)
    end
  end
end
