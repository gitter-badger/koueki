defmodule KouekiWeb.AttributeView do
  use KouekiWeb, :view

  def render("attribute.json", %{attribute: attribute}) do
    %{
      id: to_string(attribute.id),
      uuid: attribute.uuid,
      type: attribute.type,
      category: attribute.category,
      to_ids: to_string(attribute.to_ids),
      distribution: to_string(attribute.distribution),
      comment: attribute.comment,
      value: attribute.value,
      event_id: attribute.event_id,
      tags: render_many(attribute.tags, KouekiWeb.TagView, "tag.json")
    }
  end

  def render("attribute.misp.json", %{attribute: attribute}) do
    %{
      id: to_string(attribute.id),
      uuid: attribute.uuid,
      type: attribute.type,
      category: attribute.category,
      to_ids: to_string(attribute.to_ids),
      distribution: to_string(attribute.distribution),
      comment: attribute.comment,
      value: attribute.value,
      event_id: attribute.event_id,
      Tag: render_many(attribute.tags, KouekiWeb.TagView, "tag.json")
    }
  end
end
