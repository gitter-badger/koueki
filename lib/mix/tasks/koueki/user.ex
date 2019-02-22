defmodule Mix.Tasks.Koueki.User do
  use Mix.Task
  import Mix.Ecto
  import Ecto.Changeset
  alias Mix.Tasks.Koueki.Common
  alias Koueki.{User, Repo, Org}

  def run(["new", email, password]) do
    Common.start_koueki()

    org = with %Org{} = org <- Repo.get_by(Org, local: true) do
      org
    else
      _ -> 
        {:ok, org} = create_first_org()
        org
    end

    user = User.changeset(%User{}, %{email: email, password: password, org_id: org.id})

    {:ok, user} = Repo.insert(user)

    Mix.shell().info("""
    User created:
      email address: #{user.email}
      apikey: #{user.apikey}
    """)
  end

  def run(_) do
    Mix.shell().info("Task not found")
  end

  defp create_first_org do
    Mix.shell().info("No local organisation exists, let's create one!")

    Mix.shell().info("Creating Organisation...")

    name = Mix.shell().prompt("Name: ") |> String.trim()
    description = Mix.shell().prompt("Description: ") |> String.trim()

    org = Org.changeset(%Org{}, %{name: name, description: description, local: true})

    if org.valid? do
      Repo.insert(org)
    else
      create_first_org()
    end
  end

end
