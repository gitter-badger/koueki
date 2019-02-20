defmodule Koueki.User do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset

  alias Koueki.{User, Repo}

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :apikey, :string
  end

  def create(params) do
    changeset =
      %User{}
      |> cast(params, [:email, :password])
      |> validate_required([:email, :password])

    if changeset.valid? do
      hashed = Pbkdf2.hash_pwd_salt(changeset.changes[:password])
      apikey = ExRandomString.generate(length: 40, charset: :hex)

      changeset
      |> put_change(:password_hash, hashed)
      |> put_change(:apikey, apikey)
      |> Repo.insert()
    else
      {:error, changeset}
    end
  end

  def verify_password(%User{} = user, password) do
    Pbkdf2.verify_pass(password, user.password_hash)
  end
end
