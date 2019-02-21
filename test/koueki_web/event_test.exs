defmodule KouekiWeb.KouekiAPI.EventsControllerTest do
  use KouekiWeb.ConnCase

  import Koueki.Factory

  test "POST /v2/event/", %{conn: conn} do
    user = insert(:user) 

    conn =
      conn
      |> assign(:user, user)
      |> post("/v2/events/", %{info: "my event"})

    assert %{"info" => "my event"} = json_response(conn, 201)

    conn = 
      build_conn()
      |> assign(:user, user)
      |> post("/v2/events/", %{})

    assert %{"error" => %{"info" => ["can't be blank"]}} = json_response(conn, 400)

    conn = 
      build_conn()
      |> assign(:user, user)
      |> post("/v2/events/", %{info: "yui is best yuru", attributes: [
        %{type: "ip-dst", value: "8.8.8.8"}
      ]})

    assert %{"attributes" => attributes} = json_response(conn, 201)
    assert [%{"type" => "ip-dst", "value" => "8.8.8.8", "category" => "Network activity"}] = attributes

    conn =
      build_conn()
      |> assign(:user, user)
      |> post("/v2/events/", %{info: "yui is best yuru", attributes: [
        %{value: "8.8.8.8"}
      ]})

    assert %{"error" => %{"attributes" => [
      %{"type" => ["can't be blank"]}
    ]}} = json_response(conn, 400)

    conn =
      build_conn()
      |> assign(:user, user)
      |> post("/v2/events/", %{info: "yui is best yuru", attributes: [
        %{type: "ip-dst", value: "8.8.8.8", tags: [
          %{name: "plastic love"}
        ]}
      ]})

    assert %{"attributes" => [
      %{"value" => "8.8.8.8", "tags" => [%{"id" => _, "name" => "plastic love"}]}
    ]} = json_response(conn, 201)
  end
end
