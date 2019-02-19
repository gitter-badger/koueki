defmodule Mix.Tasks.Koueki.User do
  use Mix.Task
  import Mix.Ecto
  import Ecto.Changeset
  alias Mix.Tasks.Koueki.Common
  alias Koueki.{User, Repo}

  def run(["new", email, password]) do
    Common.start_koueki()

    {:ok, user} = User.create(%{email: email, password: password})

    Mix.shell().info("""
    User created:
      email address: #{user.email}
      apikey: #{user.apikey}
    """)
  end

  def run(_) do
    Mix.shell().info("Task not found")
  end
end
