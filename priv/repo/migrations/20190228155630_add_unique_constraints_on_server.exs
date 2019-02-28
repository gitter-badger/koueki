defmodule Koueki.Repo.Migrations.AddUniqueConstraintsOnServer do
  use Ecto.Migration

  def change do
    create unique_index(:servers, [:url])
    create unique_index(:servers, [:name])
  end
end
