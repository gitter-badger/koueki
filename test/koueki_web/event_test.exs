defmodule KouekiWeb.EventsTest do
  use KouekiWeb.ConnCase

  import Koueki.Factory
  import Koueki.TestHelper

  test "GET /v2/events/", %{conn: conn} do
    user = insert(:user)
    insert(:event)
    insert(:event)

    conn =
      conn
      |> assign(:user, user)
      |> get("/v2/events/")

    assert [%{}, %{}] = json_response(conn, 200)

    conn =
      build_conn()
      |> assign(:user, user)
      |> get("/v2/events/?limit=1")

    assert [%{}] = json_response(conn, 200)
  end

  test "POST /v2/events/search/", %{conn: conn} do
    user = insert(:user)
    first_tag = insert(:tag)
    second_tag = insert(:tag)

    first_event = insert(:event, tags: [first_tag, second_tag])
    second_event = insert(:event, tags: [first_tag])
    first_id = first_event.id
    second_id = second_event.id

    conn =
      conn
      |> assign(:user, user)
      |> post("/v2/events/search/", %{"and" => %{"tags" => [first_tag.name, second_tag.name]}})

    assert [%{"id" => ^first_id}] = json_response(conn, 200)

    conn = 
      build_conn()
      |> assign(:user, user)
      |> post("/v2/events/search/", %{"or" => %{"tags" => [first_tag.name, second_tag.name]}})

    assert [%{"id" => ^first_id}, %{"id" => ^second_id}] = json_response(conn, 200)

    conn =            
      build_conn()    
      |> assign(:user, user)
      |> post("/v2/events/search/",
        %{"not" => 
          %{
              "tags" => second_tag.name, 
          }
        }
      )
    assert [%{"id" => ^second_id}] = json_response(conn, 200)
  end

  test "GET /v2/events/:id", %{conn: conn} do
    user = insert(:user)
    event = insert(:event)

    conn =
      conn
      |> assign(:user, user)
      |> get("/v2/events/#{event.id}")
      |> doc()

    assert %{"info" => _} = json_response(conn, 200)
  end

  test "POST /v2/events/", %{conn: conn} do
    user = insert(:user)

    conn =
      conn
      |> assign(:user, user)
      |> post("/v2/events/", %{info: "my event"})
      |> doc()

    assert %{"info" => "my event"} = json_response(conn, 201)

    conn =
      build_conn()
      |> assign(:user, user)
      |> post("/v2/events/", %{})

    assert %{"error" => %{"info" => ["can't be blank"]}} = json_response(conn, 400)

    conn =
      build_conn()
      |> assign(:user, user)
      |> post("/v2/events/", %{
        info: "yui is best yuru",
        attributes: [
          %{type: "ip-dst", value: "8.8.8.8"}
        ]
      })

    assert %{"attributes" => attributes} = json_response(conn, 201)

    assert [%{"type" => "ip-dst", "value" => "8.8.8.8", "category" => "Network activity"}] =
             attributes

    conn =
      build_conn()
      |> assign(:user, user)
      |> post("/v2/events/", %{
        info: "yui is best yuru",
        attributes: [
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
      |> post("/v2/events/", %{
        info: "yui is best yuru",
        attributes: [
          %{
            type: "ip-dst",
            value: "8.8.8.8",
            tags: [
              %{name: "plastic love"}
            ]
          }
        ]
      })

    assert %{
             "attributes" => [
               %{"value" => "8.8.8.8", "tags" => [%{"id" => _, "name" => "plastic love"}]}
             ]
           } = json_response(conn, 201)
  end

  test "PATCH /v2/events/:id", %{conn: conn} do
    user = insert(:user)
    event = insert(:event)

    conn =
      conn
      |> assign(:user, user)
      |> patch("/v2/events/#{event.id}", %{info: "updated!"})

    assert %{"info" => "updated!"} = json_response(conn, 200)
  end

  test "DELETE /v2/events/:id", %{conn: conn} do
    user = insert(:user)
    event = insert(:event)

    conn =
      conn
      |> assign(:user, user)
      |> delete("/v2/events/#{event.id}")

    assert %{"deleted" => true} = json_response(conn, 200)
  end

  test "POST /v2/events/:id/attributes/", %{conn: conn} do
    user = insert(:user)
    event = insert(:event)

    # Entirely fine case
    ip = gen_ip()

    conn =
      conn
      |> assign(:user, user)
      |> post(
        "/v2/events/#{event.id}/attributes/",
        %{"value" => ip, "type" => "ip-dst"}
      )

    assert %{"value" => ip, "type" => "ip-dst"} = json_response(conn, 201)

    # No type given
    ip = gen_ip()

    conn =
      build_conn()
      |> assign(:user, user)
      |> post(
        "/v2/events/#{event.id}/attributes/",
        %{"value" => ip}
      )

    assert %{"error" => _} = json_response(conn, 400)

    # Wrong category
    conn =
      build_conn()
      |> assign(:user, user)
      |> post(
        "/v2/events/#{event.id}/attributes/",
        %{"value" => ip, "type" => "ip-dst", "category" => "Artifacts dropped"}
      )

    assert %{"error" => _} = json_response(conn, 400)

    # Tagging at the same time
    ip = gen_ip()

    conn =
      build_conn()
      |> assign(:user, user)
      |> post(
        "/v2/events/#{event.id}/attributes/",
        %{"value" => ip, "type" => "ip-dst", "tags" => [%{"name" => "cofe"}]}
      )

    assert %{"value" => ip, "type" => "ip-dst", "tags" => [%{"name" => "cofe"}]} =
             json_response(conn, 201)

    # Two at once
    first_ip = gen_ip()
    second_ip = gen_ip()

    conn =
      build_conn()
      |> assign(:user, user)
      |> post(
        "/v2/events/#{event.id}/attributes/",
        %{
          "_json" => [
            %{"value" => first_ip, "type" => "ip-dst"},
            %{"value" => second_ip, "type" => "ip-dst"}
          ]
        }
      )
      |> doc()

    assert [
             %{"value" => first_ip},
             %{"value" => second_ip}
           ] = json_response(conn, 201)

    # Two at once, but one is invalid
    first_ip = gen_ip()
    second_ip = gen_ip()

    conn =
      build_conn()
      |> assign(:user, user)
      |> post(
        "/v2/events/#{event.id}/attributes/",
        %{
          "_json" => [
            %{"value" => first_ip},
            %{"value" => second_ip, "type" => "ip-dst"}
          ]
        }
      )

    assert %{"error" => [%{"type" => _}]} = json_response(conn, 400)

    # Duplicate value in one transaction - should be okie!
    ip = gen_ip()

    conn =
      build_conn()
      |> assign(:user, user)
      |> post(
        "/v2/events/#{event.id}/attributes/",
        %{
          "_json" => [
            %{"value" => ip, "type" => "ip-dst"},
            %{"value" => ip, "type" => "ip-dst"}
          ]
        }
      )

    assert [%{"value" => ip}] = json_response(conn, 201)
  end

  test "GET /v2/events/:id/tags/", %{conn: conn} do
    user = insert(:user)
    tag = insert(:tag)
    event = insert(:event, tags: [tag])

    conn =
      conn
      |> assign(:user, user)
      |> get("/v2/events/#{event.id}/tags/")

    expected_name = tag.name
    assert [%{"name" => ^expected_name}] = json_response(conn, 200)
  end

  test "POST /v2/events/:id/tags/", %{conn: conn} do
    user = insert(:user)
    event = insert(:event)

    conn =
      conn
      |> assign(:user, user)
      |> post("/v2/events/#{event.id}/tags/", %{"name" => "plastic love"})

    assert %{"name" => "plastic love"} = json_response(conn, 201)

    event = insert(:event)

    conn =                           
      build_conn()
      |> assign(:user, user)         
      |> post("/v2/events/#{event.id}/tags/", %{"_json" => [
          %{"name" => "I'm just playing games"},
          %{"name" => "Pretty cool my dude"}]})

    assert [%{"name" => "I'm just playing games"},
            %{"name" => "Pretty cool my dude"}] = json_response(conn, 201)
  end
end
