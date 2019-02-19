defmodule Mix.Tasks.Koueki.Common do
  @doc "Common functions to be reused in mix tasks"
  def start_koueki do
    Mix.Task.run("app.start")
  end
end
