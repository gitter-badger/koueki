defmodule Koueki.Sync.Runner do
  import Timex
  import Ecto.Query

  alias Koueki.Server

  def run do
    from(server in Koueki.Server)
    |> Repo.all()
    |> Enum.map(fn server ->
      case server.adapter do
        "misp" ->
          {Koueki.Tasks.Sync.MISP, server.id}
        "koueki" ->
          {Koueki.Tasks.Sync.Koueki, server.id}
      end
    end)
    |> Supervisor.start_link(strategy: :one_for_one)
  end
end
