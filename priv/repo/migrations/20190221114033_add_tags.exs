defmodule Koueki.Repo.Migrations.AddTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :uuid, :uuid
      add :name, :string
      add :colour, :string
    end

    create index(:tags, [:name])

    create table(:event_tags, primary_key: false) do
      add :event_id, references(:events, on_delete: :delete_all)
      add :tag_id, references(:tags, on_delete: :delete_all)
    end

    create table(:attribute_tags, primary_key: false) do
      add :attribute_id, references(:attributes, on_delete: :delete_all)
      add :tag_id, references(:tags, on_delete: :delete_all)
    end

    drop(constraint(:attributes, "attributes_event_id_fkey"))

    alter table(:attributes) do
      modify :event_id, references(:events, on_delete: :delete_all)
    end
  end
end
