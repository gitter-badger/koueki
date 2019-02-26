defmodule Mix.Tasks.Koueki.User do
  use Mix.Task
  import Mix.Ecto
  import Ecto.Changeset
  alias Mix.Tasks.Koueki.Common
  alias Koueki.{User, Repo, Org}

  def run(["new", email | rest]) do
    {options, [], []} =
      OptionParser.parse(rest,
        strict: [
          password: :string,
          orgid: :integer
        ]
      )
  
    Common.start_koueki()

    password = case Keyword.get(options, :password) do
      nil ->
        :crypto.strong_rand_bytes(16) |> Base.encode64()
      password ->
        password
    end

    org_id = Keyword.get(options, :orgid, 1)

    with %Org{} = org <- Repo.get(Org, org_id) do
      user = User.changeset(%User{}, %{email: email, password: password, org_id: org.id})

      if user.valid? do
        {:ok, user} = Repo.insert(user)

        Mix.shell().info("""
        User created:
          email address: #{user.email}
          apikey: #{user.apikey}
          password: #{user.password}
        """)
      else
        Mix.shell().error("Issue validating user")
        Mix.shell().error(user.errors)  
      end

    else
      _ -> Mix.shell().error("Org #{org_id} not found! Create it first!")
    end
  end

  def run(_) do
    Mix.shell().info("Task not found")
  end
end
