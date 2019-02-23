defmodule Koueki.Repo.Migrations.AddEventCompositeUnique do
  use Ecto.Migration

  def change do
    create unique_index(:attributes, [:event_id, :value, :type, :category],
             name: :attribute_is_unique_constraint
           )
  end
end
