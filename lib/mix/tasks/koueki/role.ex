defmodule Mix.Tasks.Koueki.Role do
  use Mix.Task

  alias Mix.Tasks.Koueki.Common
  alias Koueki.{Repo, Role}

  def run(["new", name | rest]) do
    {options, [], []} =
      OptionParser.parse(rest,
        strict: [
          org_admin: :boolean,
          global_admin: :boolean,
          modify_own_events: :boolean,
          modify_org_events: :boolean,
          attach_tags: :boolean,
          modify_tags: :boolean,
          modify_sync: :boolean,
          default: :boolean
        ]
      )

    Common.start_koueki()

    role = %Role{
      name: name,
      is_org_admin: Keyword.get(options, :org_admin, false),
      is_global_admin: Keyword.get(options, :global_admin, false),
      can_modify_own_events: Keyword.get(options, :modify_own_events, false),
      can_modify_org_events: Keyword.get(options, :modify_org_events, false),
      can_tag: Keyword.get(options, :attach_tags, false),
      can_modify_tags: Keyword.get(options, :modify_tags, false),
      can_modify_sync: Keyword.get(options, :modify_sync, false),
      default: Keyword.get(options, :default, false)
    }

    Mix.shell().info("Creating role with these options:")
    IO.inspect(role)

    {:ok, role} = Repo.insert(role)

    Mix.shell().info("""
    Created role #{role.name} with ID #{role.id}
    """)
  end

  def run(["new"]) do
    Mix.shell().info("""
    Usage:
      mix Koueki.Role new <rolename>

    Options:
      --org-admin
      --global-admin
      --modify-own-events
      --modify-org-events
      --attach-tags
      --modify-tags
      --modify-sync
      --default
    """)
  end
end
