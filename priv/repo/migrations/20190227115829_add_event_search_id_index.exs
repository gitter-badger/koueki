defmodule Koueki.Repo.Migrations.AddEventSearchIdIndex do
  use Ecto.Migration

  def change do
    create unique_index("event_search", [:id])
  end
end
