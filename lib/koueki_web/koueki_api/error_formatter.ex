defmodule KouekiWeb.KouekiAPI.ErrorFormatter do
  alias Ecto.Changeset

  @doc """
  Take a changeset with potentially embedded changesets and retrieve a single,
  flat error array
  """
  def format_validation_error(%Changeset{changes: changes, errors: errors} = changeset) do
    this_changeset_errors = 
      errors
      |> Keyword.keys()
      |> Enum.map(fn key ->
        error_string =
          errors
          |> Keyword.get(key)
          |> Tuple.to_list()
          |> List.first()

        "#{changeset.data.__meta__.source}.#{key}: #{error_string}"
      end)

      changes
      |> Map.keys()
      |> Enum.reduce(
          this_changeset_errors,
          fn key, error_list ->
            error_list ++ format_validation_error(Map.get(changes, key))
          end
        )
      |> List.flatten()
  end

  def format_validation_error(structs) when is_list(structs) do
    Enum.map(structs, fn x -> format_validation_error(x) end)
  end

  def format_validation_error(_) do
    []
  end
end
