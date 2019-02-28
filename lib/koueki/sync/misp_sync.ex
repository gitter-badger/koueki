defmodule Koueki.Tasks.Sync.MISP do
  @moduledoc """
  The adapter to enable syncing with MISP servers. Uses legacy APIs.
  """

  use Task
  import Koueki.Tasks.Sync.Common

  alias Koueki.{
    Server,
    Event,
    Repo
  }

  def start_link(arg) do
    Task.start_link(__MODULE__, :run, [arg])
  end

  def run(arg) do
    with %Server{} = server <- Repo.get(Server, arg) do
      sync_url =
        server.url
        |> URI.merge("/events/restSearch")            
        |> URI.to_string()

      opts = generate_options(server)
      IO.inspect opts
    end
  end
end
