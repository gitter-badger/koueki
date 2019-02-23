defmodule KouekiWeb.EventView do
  use KouekiWeb, :view

  alias Koueki.{
    Event
  }

  alias KouekiWeb.{
    OrgView,
    AttributeView,
    TagView
  }

  def render("events.json", %{events: events}) do
    render_many(events, KouekiWeb.EventView, "event.json")
  end

  def render("event.json", %{event: event}) do
    %{
      id: event.id,
      uuid: event.uuid,
      published: event.published,
      info: event.info,
      threat_level_id: event.threat_level_id,
      analysis: event.analysis,
      date: to_string(event.date),
      distribution: event.distribution,
      org: OrgView.render("org.json", %{org: event.org}),
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
        org_id: to_string(event.org_id),
        orgc_id: to_string(event.org_id),
        Org: OrgView.render("org.misp.json", %{org: event.org}),
        Orgc: OrgView.render("org.misp.json", %{org: event.org}),
        Attribute: render_many(event.attributes, KouekiWeb.AttributeView, "attribute.misp.json"),
        Tag: render_many(event.tags, KouekiWeb.TagView, "tag.json")
      }
    }
  end
end
