defmodule KouekiWeb.Utils do
  def get_user(%{assigns: %{user: user}}) do
    user
  end

  def string_map_to_atoms(%{} = map) do
    Map.new(map, fn {k, v} -> {String.to_atom(k), v} end)
  end
end
