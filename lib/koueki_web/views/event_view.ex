defmodule KouekiWeb.EventView do
  use KouekiWeb, :view

  alias Koueki.{
    Event
  }

  def render("event.json", %{event: event}) do
    %{
      id: to_string(event.id),           
      uuid: event.uuid,
      published: to_string(event.published),
      info: event.info,
      threat_level_id: to_string(event.threat_level_id),
      analysis: to_string(event.analysis),
      date: to_string(event.date),
      distribution: to_string(event.distribution),
      attributes: render_many(event.attributes, KouekiWeb.AttributeView, "attribute.json"),
      tags: render_many(event.tags, KouekiWeb.TagView, "tag.json")
    }
  end

  def render("event.misp.json", %{event: event}) do
    %{
      Event: %{
        id: to_string(event.id),
        uuid: event.uuid,
        published: to_string(event.published),
        info: event.info,
        threat_level_id: to_string(event.threat_level_id),
        analysis: to_string(event.analysis),
        date: to_string(event.date),
        distribution: to_string(event.distribution),
        Attribute: render_many(event.attributes, KouekiWeb.AttributeView, "attribute.misp.json"),
        Tag: render_many(event.tags, KouekiWeb.TagView, "tag.json")
      }
    }
  end
end
