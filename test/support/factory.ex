defmodule Koueki.Factory do
  use ExMachina.Ecto, repo: Koueki.Repo

  def user_factory do
    org = insert(:org)

    %Koueki.User{
      email: "user@domain.com",
      apikey: "test",
      password_hash: Pbkdf2.hash_pwd_salt("password"),
      org: org
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
      name: sequence(:name, &"タッグ #{&1}")
    }
  end
end
