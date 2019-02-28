defmodule KouekiWeb.Status do
  use KouekiWeb, :controller

  def internal_error(conn, message) do
    conn
    |> put_status(500)
    |> json(%{error: message})
  end

  def not_found(conn, message) do
    conn
    |> put_status(404)
    |> json(%{error: message})
  end

  def bad_request(conn, message) do
    conn
    |> put_status(400)
    |> json(%{error: message})
  end

  def validation_error(conn, changeset) do
    conn
    |> put_status(400)
    |> json(%{error: KouekiWeb.ErrorFormatter.format_validation_error(changeset)})
  end

  def permission_denied(conn, message) do
    conn
    |> put_status(403)
    |> json(%{error: message})
  end
end
