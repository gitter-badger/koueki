defmodule KouekiWeb.ConfigView do
  use KouekiWeb, :view

  def render("config.json", config) do
    %{
      "signup_enabled": Map.get(config, :signup_enabled, false)
    }
  end
end
