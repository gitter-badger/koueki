defmodule Mix.Tasks.Koueki.Org do
  use Mix.Task
  alias Mix.Tasks.Koueki.Common
  alias Koueki.{Repo, Org}

  def run(["new", name | rest]) do
    Common.start_koueki()

    {options, [], []} =
      OptionParser.parse(rest,
        strict: [
          description: :string
        ]
      )

    description = Keyword.get(options, :description, "")

    org = Org.changeset(%Org{}, %{name: name, description: description, local: true})
    {:ok, org} = Repo.insert(org)
    Mix.shell().info("Org #{org.name} (id: #{org.id}) created")
  end

  def run(_) do
    Mix.shell().info("Task not found")
  end
end
