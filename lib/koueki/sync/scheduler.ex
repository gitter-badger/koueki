defmodule Koueki.Sync.Scheduler do
  @moduledoc """
  Schedules server syncs

  Sync will run once per hour!
  """
  use GenServer
  alias Koueki.Sync.Runner
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    Logger.info("Sync scheduler starting...")
    schedule_next_job()
    {:ok, nil}
  end

  def handle_info(:perform, state) do
    Runner.run()
    schedule_next_job()
    {:noreply, state}
  end

  defp schedule_next_job() do
    delay =
      Application.get_env(:koueki, :instance)
      |> Keyword.get(:sync_frequency, 60_000 * 15)

    Logger.debug("Scheduling next sync in #{delay}ms")

    Process.send_after(self(), :perform, delay)
  end
end
