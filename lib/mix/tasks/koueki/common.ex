defmodule Mix.Tasks.Koueki.Common do
  @doc "Common functions to be reused in mix tasks"
  def start_koueki do
    Mix.Task.run("app.start")
  end

  def get_option(options, opt, prompt, defval \\ nil, defname \\ nil) do
    Keyword.get(options, opt) ||
      case Mix.shell().prompt("#{prompt} [#{defname || defval}]") do
        "\n" ->
          case defval do
            nil -> get_option(options, opt, prompt, defval)
            defval -> defval
          end

        opt ->
          opt |> String.trim()
      end
  end
end
