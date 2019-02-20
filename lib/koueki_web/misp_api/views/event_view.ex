defmodule KouekiWeb.MISPAPI.EventView do
  use KouekiWeb, :view

  alias Koueki.{
    Event
  }

  def render("event.json", %Event{} = event) do
    %{
      id: to_string(event.id),
      uuid: event.uuid,
      published: to_string(event.published),
      info: event.info,
      threat_level_id: to_string(event.threat_level_id),
      analysis: to_string(event.analysis),
      date: to_string(event.date),
      distribution: to_string(event.distribution),
      Attribute: render_many(event.attributes, KouekiWeb.MISPAPI.AttributeView, "attribute.json")
    }
  end
end
