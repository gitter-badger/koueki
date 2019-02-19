defmodule Koueki.Event do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset

  alias Koueki.{
    Event
  }

  schema "events" do
    field :uuid, :binary_id
    field :published, :boolean
    field :info, :string
    field :threat_level_id, :integer, default: 4
    field :analysis, :integer, default: 0
    field :date, :date
    field :publish_timestamp, :utc_datetime
    field :attribute_count, :integer
    field :distribution, :integer, default: 0
    timestamps()

    belongs_to :org, Koueki.Org
    belongs_to :orgc, Koueki.OrgC

    has_many :attributes, Koueki.Attribute
  end

  def changeset(params) do
    %Event{}
    |> cast(params, [:published, :inof, :threat_level_id, :analysis, :date, :distribution])
    |> validate_inclusion(:threat_level_id, 1..4)
    |> validate_inclusion(:analysis, 0..2)
    |> validate_inclusion(:distribution, 0..4)
  end

end
