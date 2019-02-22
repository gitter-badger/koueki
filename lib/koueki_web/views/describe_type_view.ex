defmodule KouekiWeb.DescribeTypeView do
  def render("sane_defaults.json", types) do
    types
    |> Map.keys()
    |> Enum.reduce(
        %{},
        fn key, acc ->
          acc
          |> Map.put(key, %{
            default_category: get_in(types, [key, :defaults, :category]),
            to_ids: get_in(types, [key, :defaults, :to_ids])
          })
        end)
  end

  def render("type_mapping.json", types) do
    types
    |> Map.keys()
    |> Enum.reduce(
        %{},
        fn key, acc ->
          acc
          |> Map.put(key, get_in(types, [key, :valid_for]))
        end)
  end
end
