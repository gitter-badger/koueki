defmodule Koueki.Attribute.Search do
  use Ecto.Schema
  import Ecto.Query
  import Koueki.Search

  alias Koueki.Ecto.Types.TSVectorType

  schema "attribute_search" do
    field :comment, TSVectorType
    field :tags, TSVectorType
    field :category, TSVectorType
    field :type, TSVectorType
    field :value, TSVectorType
  end

  def run(params) do
    search_params = maybe_wrap(params)
    initial_condition = get_initial_condition(search_params)
    conditions = generate(search_params, condition: initial_condition)
    attribute_ids =
      from(attribute in Koueki.Attribute.Search, select: attribute.id, where: ^conditions)

    page =
      from(
        attribute in Koueki.Attribute,
        join: s in subquery(attribute_ids),
        on: s.id == attribute.id,
        preload: [:org, :tags]
      )
      |> Koueki.Repo.paginate(
        page: Map.get(params, "page", 0),
        page_size: Map.get(params, "limit", 20)
      )

    {page.entries, page.total_pages}
  end

  defp generate(params, opts \\ [condition: "|"])

  defp generate(%{"and" => %{} = params}, opts) do
    params
    |> Map.keys()
    |> Enum.reduce(
      true,
      fn key, conditions ->
        dynamic(
          [attribute],
          ^conditions and ^generate(Map.take(params, [key]), condition: "&")
        )
      end
    )
  end

  defp generate(%{"or" => %{} = params}, opts) do
    params
    |> Map.keys()
    |> Enum.reduce(
      true,
      fn key, conditions ->
        dynamic([attribute], ^conditions or ^generate(Map.take(params, [key]), condition: "|"))
      end
    )
  end

  defp generate(%{"not" => %{} = params}, opts) do
    if_true =
      params
      |> Map.keys()
      |> Enum.reduce(
        true,
        fn key, conditions ->
          dynamic([attribute], ^conditions and ^generate(Map.take(params, [key])))
        end
      )

    dynamic([attribute], not (^if_true))
  end

  defp generate(%{"id" => value}, opts) do
    dynamic([attribute], attribute.id == ^value)
  end

  defp generate(%{"comment" => value}, opts) do
    dynamic(
      [attribute],
      fragment("? @@ to_tsquery(?)", attribute.comment, ^value_to_ts(value, opts))
    )
  end

  defp generate(%{"tags" => value}, opts) do
    dynamic(
      [attribute],
      fragment("? @@ to_tsquery(?)", attribute.tags, ^value_to_ts(value, opts))
    )
  end

  defp generate(%{"category" => value}, opts) do
    dynamic(
      [attribute],
      fragment("? @@ to_tsquery(?)", attribute.category, ^value_to_ts(value, opts))
    )
  end

  defp generate(%{"type" => value}, opts) do
    dynamic(
      [attribute],
      fragment("? @@ to_tsquery(?)", attribute.type, ^value_to_ts(value, opts))
    )
  end

  defp generate(%{"value" => value}, opts) do
    dynamic(
      [attribute],
      fragment("? @@ to_tsquery(?)", attribute.value, ^value_to_ts(value, opts))
    )
  end

  defp generate(_, opts) do
    case opts[:condition] do
      "&" -> true
      "|" -> false
    end
  end
end
