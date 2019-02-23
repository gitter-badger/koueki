defmodule KouekiWeb.MISPAPI.AttributeTest do
  use KouekiWeb.ConnCase

  import Koueki.Factory
  import Koueki.TestHelper

  test "POST /v1/attributes/add/:event_id", %{conn: conn} do
    user = insert(:user)
    event = insert(:event)

    ip = gen_ip()

    conn =
      conn
      |> assign(:user, user)
      |> post(
        "/v1/attributes/add/#{event.id}",
        %{"value" => ip, "type" => "ip-dst"}
      )

    assert %{"Attribute" => %{"value" => ip, "type" => "ip-dst"}} = json_response(conn, 201)

    ip = gen_ip()

    conn =
      build_conn()
      |> assign(:user, user)
      |> post(
        "/v1/attributes/add/#{event.id}",
        %{"value" => ip}
      )

    assert %{"error" => _} = json_response(conn, 400)

    conn =
      build_conn()
      |> assign(:user, user)
      |> post(
        "/v1/attributes/add/#{event.id}",
        %{"value" => ip, "type" => "ip-dst", "category" => "Artifacts dropped"}
      )

    assert %{"error" => _} = json_response(conn, 400)

    ip = gen_ip()

    conn =
      build_conn()
      |> assign(:user, user)
      |> post(
        "/v1/attributes/add/#{event.id}",
        %{"value" => ip, "type" => "ip-dst", "Tag" => [%{"name" => "cofe"}]}
      )

    assert %{"Attribute" => %{"value" => ip, "type" => "ip-dst"}} = json_response(conn, 201)
  end
end
