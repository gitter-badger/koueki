defmodule Koueki.Event.Search do
  use Ecto.Schema
  import Ecto.Query

  alias Koueki.Ecto.Types.TSVectorType

  schema "event_search" do
    field :info, TSVectorType
    field :tags, TSVectorType
    field :category, TSVectorType
    field :type, TSVectorType
    field :value, TSVectorType
  end

  @doc """
  Search through our events

  This is a bit of heccing crazy logic so I'll explain what we're trying to do

  Given parameters of the form
    %{or: %{value: "a", info: "b"}}

  We want to evaluate it as
    SELECT * FROM events WHERE events.value = 'a' OR events.info = 'b';

  This gets a bit more complex with arrays. Array will inherit the
  matching condition from their parent, like so:

    %{or: %{info: ["a", "b"]}}

    SELECT * FROM events WHERE events.info = 'a' OR events.info = 'b';

  And so on.

  A more complex example:

    %{and: %{info: "a", or: %{tags: ["b", "c"]}}}

    SELECT * FROM events WHERE events.info = 'a' AND (events.tags = 'b' OR events.tag = 'c')

  We're not using direct string matches like that in practice, but it gives
  you an idea of the sort of thing we're trying to achieve
  """
  def run(params) do

    needs_wrap? = not(
      ["and", "or", "not"]
      |> Enum.any?(fn x -> Map.has_key?(params, x) end)
    )

    search_params = 
      if needs_wrap? do
        %{"and" => params}
      else
        params
      end

    outer_key = 
      search_params
      |> Map.keys()
      |> List.first()

    initial_condition =
      case outer_key do
        "or" -> "|"
        "and" -> "&"
        "not" -> "&"
      end

    conditions = generate(search_params, condition: initial_condition)

    event_ids = 
      from(event in Koueki.Event.Search, select: event.id, where: ^conditions)
   
    page = 
      from(
        event in Koueki.Event,
        join: s in subquery(event_ids),
        on: s.id == event.id,
        left_join: attributes in assoc(event, :attributes),
        left_join: attr_tags in assoc(attributes, :tags),
        preload: [:org, :tags, attributes: {attributes, tags: attr_tags}]
      )
      |> Koueki.Repo.paginate(
        page: Map.get(params, "page", 0),
        page_size: Map.get(params, "limit", 20)
      )

    {page.entries, page.total_pages}
  end

  defp value_to_ts(value, opts) when is_list(value) do
    value
    |> Enum.map(fn x -> value_to_ts(x, opts) end)
    |> Enum.join(opts[:condition])
  end

  defp value_to_ts(value, opts) do
    value
    |> String.replace(" ", "&")
    |> String.replace_trailing("*", ":*")
  end

  defp generate(params, opts \\ [condition: "|"])

  defp generate(%{"and" => %{} = params}, opts) do
    params
    |> Map.keys()
    |> Enum.reduce(
      true,
      fn key, conditions ->
        dynamic([event],
          (^conditions and ^generate(Map.take(params, [key]), [condition: "&"])))
      end)
  end

  defp generate(%{"or" => %{} = params}, opts) do
    params
    |> Map.keys()
    |> Enum.reduce(
      true,
      fn key, conditions ->
        dynamic([event], (^conditions or ^generate(Map.take(params, [key]), [condition: "|"])))
      end)
  end

  defp generate(%{"not" => %{} = params}, opts) do
    if_true = 
      params
      |> Map.keys()
      |> Enum.reduce(
        true,
        fn key, conditions ->
          dynamic([event], (^conditions and ^generate(Map.take(params, [key]))))
        end)
    dynamic([event], not ^if_true)
  end

  defp generate(%{"info" => value}, opts) do
    dynamic([event], fragment("? @@ to_tsquery(?)", event.info, ^value_to_ts(value, opts)))
  end

  defp generate(%{"tags" => value}, opts) do
    dynamic([event], fragment("? @@ to_tsquery(?)", event.tags, ^value_to_ts(value, opts)))
  end

  defp generate(%{"category" => value}, opts) do
    dynamic([event], fragment("? @@ to_tsquery(?)", event.category, ^value_to_ts(value, opts))) 
  end

  defp generate(%{"type" => value}, opts) do   
    dynamic([event], fragment("? @@ to_tsquery(?)", event.type, ^value_to_ts(value, opts)))
  end

  defp generate(%{"value" => value}, opts) do   
    dynamic([event], fragment("? @@ to_tsquery(?)", event.value, ^value_to_ts(value, opts)))
  end

  defp generate(_, opts) do
    case opts[:condition] do
      "&" -> true
      "|" -> false
    end
  end
end
