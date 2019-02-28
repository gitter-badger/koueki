defmodule Koueki.Repo.Migrations.AddIdConstraintToAttributeSearch do
  use Ecto.Migration

  def change do
    create unique_index("attribute_search", [:id])
  end
end
