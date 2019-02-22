defmodule KouekiWeb.TagTest do
  use KouekiWeb.ConnCase

  import Koueki.Factory

  test "GET /v2/tags/:id", %{conn: conn} do
    user = insert(:user)
    tag = insert(:tag)

    conn =
      conn
      |> assign(:user, user)
      |> get("/v2/tags/#{tag.id}")

    assert %{"name" => _, "id" => _} = json_response(conn, 200)
  end

  test "POST /v2/tags/", %{conn: conn} do
    user = insert(:user)

    conn =
      conn
      |> assign(:user, user)
      |> post("/v2/tags/", %{name: "taggerino"})

    assert %{"name" => "taggerino", "id" => id} = json_response(conn, 201)

    # Same name - fail
    conn =
      build_conn()
      |> assign(:user, user)
      |> post("/v2/tags/", %{name: "taggerino"})

    assert %{"error" => _} = json_response(conn, 400)
  end
end
