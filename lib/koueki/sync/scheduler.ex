defmodule Koueki.Sync.Scheduler do
  @moduledoc """
  Schedules server syncs

  Sync will run once per hour!
  """
  use GenServer
  alias Koueki.Sync.Runner

  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    schedule_next_job()
    {:ok, nil}
  end

  def handle_info(:perform, state) do
    Runner.run()
    schedule_next_job()
    {:noreply, state}
  end

  defp schedule_next_job() do
    Process.send_after(self(), :perform, 60_000 * 15)
  end
end
