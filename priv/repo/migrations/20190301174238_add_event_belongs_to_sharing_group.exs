defmodule Koueki.Repo.Migrations.AddEventBelongsToSharingGroup do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :sharing_group_id, references(:sharing_groups)
    end
  end
end
