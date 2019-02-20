defmodule Koueki.Attribute do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset

  alias Koueki.{
    Attribute
  }

  alias Ecto.{
    Changeset
  }

  schema "attributes" do
    field :uuid, :binary_id
    field :type, :string
    field :category, :string
    field :to_ids, :boolean
    field :distribution, :integer
    field :comment, :string, default: ""
    field :deleted, :boolean, default: false
    field :data, :string
    field :value, :string

    timestamps()
    belongs_to :event, Koueki.Event
  end

  def changeset(params) do
    %Attribute{}
    |> cast(params, [:type, :category, :to_ids, :distribution, :comment, :value])
    |> validate_required([:type, :category, :value])
    |> validate_inclusion(:distribution, 0..5)
    |> validate_inclusion(:category, Koueki.Validation.Category.valid_categories)
    |> validate_type()
  end

  defp validate_type(%Changeset{changes: %{category: category}} = changeset) do
    valid_types = Koueki.Validation.Type.valid_types(category)
    validate_inclusion(changeset, :type, valid_types)
  end
end
