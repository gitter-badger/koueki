defmodule Koueki.Repo.Migrations.RemoveServerCertDefaults do
  use Ecto.Migration

  def change do
    alter table(:servers) do
      modify :server_certificate, :text, default: nil
      modify :client_certificate, :text, default: nil
    end
  end
end
