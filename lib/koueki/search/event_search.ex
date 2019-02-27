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
    needs_wrap? = Map.has_key?(params, "and") or Map.has_key?(params, "or")

    params = 
      if needs_wrap? do
        %{"or" => params}
      else
        params
      end

    outer_key = 
      params
      |> Map.keys()
      |> List.first()

    initial_condition =
      case outer_key do
        "or" -> "|"
        "and" -> "&"
        "not" -> "&"
      end

    # Nothing should match at the beginning
    # Conditions will be layered up, so we want false OR (conds)
    conditions =
      initial_condition 
      |> String.equivalent?("&")
      |> generate(params, condition: initial_condition)

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

  defp generate(conditions, params, opts \\ [condition: "|"])

  defp generate(conditions, %{"and" => %{} = params}, opts) do
    params
    |> Map.keys()
    |> Enum.reduce(
      conditions,
      fn query_param, conditions ->
          case opts[:condition] do
            "|" ->
               dynamic([event],
                ^conditions or ^generate(conditions, %{query_param => params[query_param]}, [condition: "&"]))
            "&" ->
              dynamic([event],
                ^conditions and ^generate(conditions, %{query_param => params[query_param]}, [condition: "&"]))
        end
      end)
  end

  defp generate(conditions, %{"or" => %{} = params}, opts) do
    params                                           
    |> Map.keys()
    |> Enum.reduce(
      conditions, 
      fn query_param, conditions ->
        case opts[:condition] do
            "|" ->      
               dynamic([event],
                ^conditions or ^generate(conditions, %{query_param => params[query_param]}, [condition: "|"]))         
            "&" ->      
              dynamic([event],
                ^conditions and ^generate(conditions, %{query_param => params[query_param]}, [condition: "|"]))
        end
      end)
  end

  defp generate(conditions, %{"not" => %{} = params}, opts) do
    params                                          
    |> Map.keys()
    |> Enum.reduce(
      conditions,
      fn query_param, conditions ->
        case opts[:condition] do
            "|" ->
               dynamic([event],
                ^conditions or not ^generate(conditions, %{query_param => params[query_param]}, [condition: "|"]))
            "&" ->
              dynamic([event],
                ^conditions and not ^generate(conditions, %{query_param => params[query_param]}, [condition: "|"]))
        end
      end)                 
  end

  defp generate(conditions, %{"info" => value}, opts) do
    dynamic([event], fragment("? @@ to_tsquery(?)", event.info, ^value_to_ts(value, opts)))
  end

  defp generate(conditions, %{"tags" => value}, opts) do
    dynamic([event], fragment("? @@ to_tsquery(?)", event.tags, ^value_to_ts(value, opts)))
  end

  defp generate(conditions, %{"category" => value}, opts) do
    dynamic([event], fragment("? @@ to_tsquery(?)", event.category, ^value_to_ts(value, opts))) 
  end

  defp generate(conditions, %{"type" => value}, opts) do   
    dynamic([event], fragment("? @@ to_tsquery(?)", event.type, ^value_to_ts(value, opts)))
  end

  defp generate(conditions, %{"value" => value}, opts) do   
    dynamic([event], fragment("? @@ to_tsquery(?)", event.value, ^value_to_ts(value, opts)))
  end

  defp generate(conditions, _, _), do: conditions
end
