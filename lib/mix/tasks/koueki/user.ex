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
          orgname: :string,
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

    org_id = Keyword.get(options, :orgid)
    org_name = Keyword.get(options, :orgname)

    org = cond do
      not is_nil(org_id) ->
        Mix.shell().info("Using org id #{org_id}")
        Repo.get(Org, org_id)
      not is_nil(org_name) ->
        Mix.shell().info("Using org name #{org_name}")
        Repo.get_by(Org, name: org_name)
      true ->
        Mix.shell().error("Required: either --orgname or --orgid")
        exit({:shutdown, 1})
    end

    with %Org{} = org do
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

  def run(["exists", email]) do
    Common.start_koueki()
    with %User{} = user <- Repo.get_by(User, email: email) do
      Mix.shell().info("User #{email} exists!")
      exit({:shutdown, 0})
    else
      _ ->
        Mix.shell().info("User #{email} does not exist!")
        exit({:shutdown, 1})
    end
  end

  def run(_) do
    Mix.shell().info("Task not found")
  end
end
