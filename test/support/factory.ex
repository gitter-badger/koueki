defmodule Koueki.Factory do
  use ExMachina.Ecto, repo: Koueki.Repo

  def user_factory do
    org = insert(:org)
    role = insert(:role)

    %Koueki.User{
      email: "user@domain.com",
      apikey: "test",
      password_hash: Pbkdf2.hash_pwd_salt("password"),
      org: org,
      role: role
    }
  end

  def org_factory do
    %Koueki.Org{
      name: sequence(:name, &"Organisation #{&1}"),
      description: "Yui is best yuru"
    }
  end

  def event_factory do
    org = insert(:org)

    %Koueki.Event{
      info: sequence(:info, &"Entirely real event #{&1}"),
      org: org
    }
  end

  def tag_factory do
    %Koueki.Tag{
      name: sequence(:name, &"Taggo #{&1}")
    }
  end

  def role_factory do
    %Koueki.Role{
      name: sequence(:name, &"Role #{&1}"),
      is_org_admin: false,
      is_global_admin: true,
      can_modify_org_events: false,
      can_modify_own_events: false
    }
  end
end
