defmodule Koueki.Factory do
  use ExMachina.Ecto, repo: Koueki.Repo

  def user_factory do
    %Koueki.User{
      email: "user@domain.com",
      apikey: "test",
      password_hash: Pbkdf2.hash_pwd_salt("password")
    }
  end
end
