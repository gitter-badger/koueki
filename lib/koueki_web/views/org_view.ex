defmodule KouekiWeb.OrgView do
  use KouekiWeb, :view

  def render("orgs.json", %{orgs: orgs}) do
    render_many(orgs, KouekiWeb.OrgView, "org.json")
  end
    
  def render("org.json", %{org: org}) do
    %{
      id: org.id,
      name: org.name,
      uuid: org.uuid,
      description: org.description
    }
  end

  def render("org.misp.json", %{org: org}) do
    %{
      id: to_string(org.id),
      name: org.name,
      uuid: org.uuid,
      description: org.description
    }
  end
end
