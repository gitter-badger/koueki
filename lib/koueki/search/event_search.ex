defmodule Koueki.Event.Search do
  use Ecto.Schema
  import Ecto.Query
  import Koueki.Search
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
    search_params = maybe_wrap(params)
    initial_condition = get_initial_condition(search_params)

    conditions = generate(search_params, condition: initial_condition)

    event_ids =
      from(
        event in Koueki.Event.Search,
        select: event.id,
        where: ^conditions
      )

    page =
      from(
        event in Koueki.Event,
        join: s in subquery(event_ids),
        on: s.id == event.id,
        preload: [:org, :tags, attributes: :tags],
        order_by: [desc: event.id]
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
          [event],
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
        dynamic([event], ^conditions or ^generate(Map.take(params, [key]), condition: "|"))
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
          dynamic([event], ^conditions and ^generate(Map.take(params, [key])))
        end
      )

    dynamic([event], not (^if_true))
  end

  defp generate(%{"id" => value}, opts) do
    dynamic([event], event.id == ^value)
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
