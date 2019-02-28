defmodule Koueki.Sync.MISP do
  @moduledoc """
  The adapter to enable syncing with MISP servers. Uses legacy APIs.
  """

  use Task
  import Koueki.Tasks.Sync.Common
  require Logger

  alias Koueki.{
    Server,
    Event,
    Repo,
    HTTPAdapters
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
  
      {:ok, post_body} = 
        %{from: DateTime.to_iso8601(server.last_sync)}
        |> Jason.encode()
 
      resp = HTTPAdapters.MISP.request(:post, server, sync_url, post_body)
      case resp do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          {:ok, body} = Jason.decode(body)
          events =  
            body
            |> Map.get("response")
            |> Enum.map(fn event -> 
              event
              |> Map.get("Event")
              |> Event.normalise_from_misp()
              |> Map.put("org_id", server.org_id)
              |> (&Event.changeset(%Event{}, &1)).()
              |> Repo.insert()
             end)
          {:ok, time} = DateTime.now("Etc/UTC")
          changeset = Server.changeset(server, %{last_sync: time})
          {:ok, serer} = Repo.update(changeset)

        {:ok, %HTTPoison.Response{status_code: code, body: body}} ->
          Logger.error("Server #{server.id} returned status #{code}")
          Logger.error(body)
        {:error, reason} ->
          Logger.error("HTTP Error on sync")
          IO.inspect reason 
      end
    end
  end
end
