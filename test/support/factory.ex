defmodule Koueki.Factory do
  use ExMachina.Ecto, repo: Koueki.Repo

  def user_factory do
    %Koueki.User{
      email: "user@domain.com",
      apikey: "test",
      password_hash: Pbkdf2.hash_pwd_salt("password")
    }
  end

  def event_factory do
    %Koueki.Event{
      info: sequence(:info, &"Entirely real event #{&1}")
    }
  end

  def tag_factory do
    %Koueki.Tag{
      name: sequence(:name, &"タッグ #{&1}")
    }
  end
end
