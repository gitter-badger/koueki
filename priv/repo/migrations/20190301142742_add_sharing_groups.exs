defmodule Koueki.Repo.Migrations.AddSharingGroups do
  use Ecto.Migration

  def change do
    create table(:sharing_groups) do
      add :name, :string
      add :releasability, :text
      add :description, :text
      add :uuid, :uuid
      add :active, :boolean
    end

    create table(:sharing_group_orgs) do
      add :sharing_group_id, references(:sharing_groups, on_delete: :delete_all)
      add :org_id, references(:orgs, on_delete: :delete_all)
    end
  end
end
