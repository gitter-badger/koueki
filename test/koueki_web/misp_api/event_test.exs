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
  end
end
