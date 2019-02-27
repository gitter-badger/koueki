defmodule Koueki.Search do
  def needs_wrap?(params) do
    not (["and", "or", "not"]
         |> Enum.any?(fn x -> Map.has_key?(params, x) end))
  end

  @doc """
  If we don't have a valid boolean on the outside of our struct,
  add one in to make processing easier
  """
  def maybe_wrap(params, opts \\ [with: "and"]) do
    if needs_wrap?(params) do
      %{opts[:with] => params}
    else
      params
    end
  end

  def get_initial_condition(params) do
    params
    |> Map.keys()
    |> List.first()
    |> case do
      "or" -> "|"
      "and" -> "&"
      "not" -> "&"
    end
  end

  @doc """
  Take an scalar or array value, and clean it for postgres
    iex> value_to_ts("hello*") 
    hello:*

    iex> value_to_ts(["val1", "val2"], condition: "|")
    val1|val2
  """
  def value_to_ts(value, opts) when is_list(value) do
    value
    |> Enum.map(fn x -> value_to_ts(x, opts) end)
    |> Enum.join(opts[:condition])
  end

  def value_to_ts(value, opts) do
    value
    |> String.replace(" ", "&")
    |> String.replace_trailing("*", ":*")
  end
end
