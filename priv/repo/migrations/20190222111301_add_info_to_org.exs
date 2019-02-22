defmodule Koueki.Repo.Migrations.AddInfoToOrg do
  use Ecto.Migration

  def change do
    alter table(:orgs) do
      add :description, :text
      add :created_by, :string
      add :local, :boolean
      timestamps()
    end
  end
end
