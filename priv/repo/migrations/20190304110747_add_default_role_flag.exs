defmodule Koueki.Repo.Migrations.AddDefaultRoleFlag do
  use Ecto.Migration

  def change do
    alter table(:roles) do
      add :default, :boolean, default: false
    end
  end
end
