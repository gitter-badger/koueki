defmodule Koueki.Repo.Migrations.AddServerAdapterId do
  use Ecto.Migration

  def change do
    alter table(:servers) do
      add :adapter, :string, null: false
    end
  end
end
