defmodule Mix.Tasks.Koueki.Org do
  use Mix.Task
  import Mix.Ecto
  import Ecto.Changeset
  alias Mix.Tasks.Koueki.Common
  alias Koueki.{User, Repo, Org}

  def run(["initial", name]) do
    Common.start_koueki()

    org = Org.changeset(%Org{}, %{name: name, local: true})
    {:ok, org} = Repo.insert(org)
    Mix.shell().info("Org #{org.name} created")
  
  end

  def run(_) do
    Mix.shell().info("Task not found")
  end
end
