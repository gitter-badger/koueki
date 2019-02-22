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

  def render("type_mapping.json", categories, types) do
    categories
    |> Enum.reduce(
        %{},
        fn category, acc ->
          acc
          |> Map.put(category, 
            types
            |> Map.keys()
            |> Enum.filter(fn type ->
                get_in(types, [type, :valid_for])
                |> Enum.member?(category)
            end)
          )
        end)
  end
end
