defmodule KouekiWeb.MISPAPI.EventsTest do
  use KouekiWeb.ConnCase

  import Koueki.Factory

  test "GET /v1/events/view/:id", %{conn: conn} do
    user = insert(:user)
    event = insert(:event)

    conn =
      conn
      |> assign(:user, user)
      |> get("/v1/events/view/#{event.id}")

    assert %{"Event" => %{"info" => _}} = json_response(conn, 200)
  end

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
      |> post("/v1/events/", %{
        Event: %{
          info: "yui is best yuru",
          Attribute: [
            %{type: "ip-dst", value: "8.8.8.8"}
          ]
        }
      })

    assert %{"Event" => %{"Attribute" => attributes}} = json_response(conn, 201)

    assert [%{"type" => "ip-dst", "value" => "8.8.8.8", "category" => "Network activity"}] =
             attributes

    conn =
      build_conn()
      |> assign(:user, user)
      |> post("/v1/events/", %{
        info: "yui is best yuru",
        Attribute: [
          %{value: "8.8.8.8"}
        ]
      })

    assert %{
             "error" => %{
               "attributes" => [
                 %{"type" => ["can't be blank"]}
               ]
             }
           } = json_response(conn, 400)

    conn =
      build_conn()
      |> assign(:user, user)
      |> post("/v1/events/", %{
        info: "yui is best yuru",
        Attribute: [
          %{
            type: "ip-dst",
            value: "8.8.8.8",
            Tag: [
              %{name: "plastic love"}
            ]
          }
        ]
      })

    assert %{
             "Event" => %{
               "Attribute" => [
                 %{"value" => "8.8.8.8", "Tag" => [%{"id" => _, "name" => "plastic love"}]}
               ]
             }
           } = json_response(conn, 201)
  end
end
