defmodule KouekiWeb.ErrorFormatter do
  alias Ecto.Changeset

  alias KouekiWeb.ErrorHelpers

  @doc """
  Take a changeset with potentially embedded changesets and retrieve a single,
  flat error array
  """
  def format_validation_error(%Changeset{} = changeset) do
    Ecto.Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)
  end
end
