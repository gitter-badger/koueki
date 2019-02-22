defmodule Koueki.Repo.Migrations.DropOrgcFromEvent do
  use Ecto.Migration

  def change do
    alter table(:events) do
      remove :orgc_id
    end
  end
end
