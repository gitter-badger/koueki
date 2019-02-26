defmodule Koueki.Repo.Migrations.AddUniqueIndexes do
  use Ecto.Migration

  def change do
    create unique_index(:attributes, [:uuid])
    create unique_index(:users, [:email])
    create unique_index(:orgs, [:uuid])
    create unique_index(:orgs, [:name])
    drop index(:events, [:uuid])
    create unique_index(:events, [:uuid])
  end
end
