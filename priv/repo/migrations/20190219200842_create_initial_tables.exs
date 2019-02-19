defmodule Koueki.Repo.Migrations.CreateInitialTables do
  use Ecto.Migration

  def change do

    create table (:orgcs) do
      add :uuid, :binary_id
      add :name, :string
    end

    create table (:orgs) do
      add :uuid, :binary_id
      add :name, :string
    end

    create table(:events) do
      add :uuid, :binary_id
      add :published, :boolean
      add :info, :string
      add :threat_level_id, :integer, default: 4
      add :analysis, :integer, default: 0
      add :date, :date
      add :publish_timestamp, :utc_datetime
      add :attribute_count, :integer
      add :distribution, :integer, default: 0
      add :org_id, references(:orgs)
      add :orgc_id, references(:orgcs)
      timestamps()
    end

    create table (:attributes) do
      add :uuid, :binary_id
      add :type, :string
      add :category, :string
      add :to_ids, :boolean 
      add :distribution, :integer
      add :comment, :string, default: ""
      add :deleted, :boolean, default: false
      add :data, :string
      add :value, :string
      add :event_id, references(:events)
      timestamps()
    end

    create index(:events, [:uuid])
    create index(:attributes, [:uuid, :type, :category])
  end
end
