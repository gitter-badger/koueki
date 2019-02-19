defmodule Koueki.Repo.Migrations.CreateUserTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :password_hash, :string
      add :apikey, :string
    end

    create index(:users, [:email, :apikey])
  end
end
