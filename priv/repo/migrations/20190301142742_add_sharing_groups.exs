defmodule Koueki.Repo.Migrations.AddSharingGroups do
  use Ecto.Migration

  def change do
    create table(:sharinggroups) do
      add :name, :string
      add :releasability, :text
      add :description, :text
      add :uuid, :uuid
      add :active, :boolean
    end

    create table(:sharinggroup_orgs) do
      add :sharinggroup_id, references(:sharinggroups, on_delete: :delete_all)
      add :org_id, references(:orgs, on_delete: :delete_all)
    end
  end
end
