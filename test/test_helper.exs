{:ok, _} = Application.ensure_all_started(:ex_machina)
ExUnit.start(formatters: [ExUnit.CLIFormatter, Bureaucrat.Formatter])
Bureaucrat.start(default_path: "doc/API.md", json_library: Jason)
Ecto.Adapters.SQL.Sandbox.mode(Koueki.Repo, :manual)
