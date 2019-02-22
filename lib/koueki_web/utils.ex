defmodule KouekiWeb.Utils do
  def get_user(%{assigns: %{user: user}}) do
    user
  end
end
