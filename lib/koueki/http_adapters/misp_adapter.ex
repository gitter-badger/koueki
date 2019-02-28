defmodule Koueki.HTTPAdapters.MISP do
  alias Koueki.Server
  require Logger

  def request(:get, %{} = server, path) do
    headers = generate_headers(server)
    opts = generate_options(server)

    server
    |> get_full_url(path)
    |> HTTPoison.get(headers, opts)
  end

  def request(:post, %{} = server, path, body) do
    headers = generate_headers(server)
    opts = generate_options(server)

    server
    |> get_full_url(path)
    |> HTTPoison.post(body, headers, opts)
  end

  defp generate_headers(%{apikey: apikey}) do
    [
      {"Content-Type", "application/json"},
      {"Accept", "application/json"},
      {"Authorization", apikey}
    ]
  end
    
  defp get_full_url(%{url: url}, path) do
    url
    |> URI.merge(path)
    |> URI.to_string()
  end

  def cleanup(%{id: id}) do
    File.rm("server.#{id}.cacert")
    File.rm("server.#{id}.cert")
  end

  def generate_options(%{} = server) do
    []
    |> maybe_add_insecure(server)
    |> generate_ssl_options(server)
  end

  defp maybe_add_insecure(opts, %{skip_ssl_validation: true}) do
    Keyword.put(opts, :insecure, true)
  end

  defp maybe_add_insecure(opts, _), do: opts

  defp generate_ssl_options(opts, %{} = server) do
    ssl_opts =
      []
      |> add_server_certificate(server)
      |> add_client_certificate(server)
    Keyword.put(opts, :ssl, ssl_opts)
  end

  defp add_server_certificate(ssl_options, %{server_certificate: nil}) do
    ssl_options
  end

  defp add_server_certificate(ssl_options, %{id: id, server_certificate: server_certificate}) do
    filename = "server.#{id}.cacert"
    case File.write(filename, server_certificate) do
      :ok ->
        ssl_options
        |> Keyword.put(:cacertfile, filename)
      {:erorr, reason} ->
        Logger.error("Could not write cacert!")
    end
  end

  defp add_server_certificate(ssl_options, _) do
    ssl_options
  end

  defp add_client_certificate(ssl_options, %{client_certificate: nil}) do
    ssl_options
  end

  defp add_client_certificate(ssl_options, %{id: id, client_certificate: client_certificate}) do
    filename = "server.#{id}.cert"

    case File.write(filename, client_certificate) do
      :ok ->
        ssl_options
        |> Keyword.put(:certfile, filename)
      {:erorr, reason} ->
        Logger.error("Could not write client cert!")
    end
  end

  defp add_client_certificate(ssl_options, _) do
    ssl_options
  end

end
