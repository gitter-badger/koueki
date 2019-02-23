defmodule KouekiWeb.OrgView do
  use KouekiWeb, :view

  def render("org.json", %{org: org}) do
    %{
      id: org.id,
      name: org.name,
      uuid: org.uuid
    }
  end

  def render("org.misp.json", %{org: org}) do
    %{
      id: to_string(org.id),
      name: org.name,
      uuid: org.uuid
    }
  end
end
