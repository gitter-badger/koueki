defmodule KouekiWeb.MISPAPI.EventsControllerTest do
  use KouekiWeb.ConnCase

  import Koueki.Factory

  test "POST /v1/event/", %{conn: conn} do
    user = insert(:user) 

    conn =
      conn
      |> assign(:user, user)
      |> post("/v1/events/", %{Event: %{info: "my event"}})

    assert %{"Event" => %{"info" => "my event"}} = json_response(conn, 201)

    conn = 
      build_conn()
      |> assign(:user, user)
      |> post("/v1/events/", %{Event: %{}})

    assert %{"error" => %{"info" => ["can't be blank"]}} = json_response(conn, 400)

    conn = 
      build_conn()
      |> assign(:user, user)
      |> post("/v1/events/", %{Event: %{info: "yui is best yuru", Attribute: [
        %{type: "ip-dst", value: "8.8.8.8"}
      ]}})

    assert %{"Event" => %{"Attribute" => attributes}} = json_response(conn, 201)
    assert [%{"type" => "ip-dst", "value" => "8.8.8.8", "category" => "Network activity"}] = attributes
      
  end
end
