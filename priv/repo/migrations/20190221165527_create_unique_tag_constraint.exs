defmodule Koueki.Repo.Migrations.CreateUniqueTagConstraint do
  use Ecto.Migration

  def change do
    drop index(:tags, [:name])
    create unique_index(:tags, [:name])
  end
end
