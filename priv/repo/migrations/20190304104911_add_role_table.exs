defmodule Koueki.Repo.Migrations.AddRoleTable do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :name, :string
      add :is_org_admin, :boolean, default: false
      add :is_global_admin, :boolean, default: false
      add :can_modify_own_events, :boolean, default: false
      add :can_modify_org_events, :boolean, default: false
      add :can_publish_events, :boolean, default: false
      add :can_tag, :boolean, default: false
      add :can_modify_tags, :boolean, default: false
      add :can_modify_sync, :boolean, default: false
    end

    alter table(:tags) do
      add :org_id, references(:orgs, on_delete: :delete_all)
    end

    alter table(:events) do
      add :user_id, references(:users, on_delete: :nilify_all)
    end
  end
end
