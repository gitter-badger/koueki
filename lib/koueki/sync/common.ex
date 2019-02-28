defmodule Koueki.Tasks.Sync.Common do
  alias Koueki.Server

  def cleanup(%Server{id: id}) do
    File.rm("server.#{server.id}.cacert")
    File.rm("server.#{server.id}.cert")
  end

  def generate_options(%Server{} = server) do
    []
    |> maybe_add_insecure(server)
    |> generate_ssl_options()
  end

  defp maybe_add_insecure(opts, %Server{skip_ssl_validation: true}) do
    Keyword.add(opts, :insecure, true)
  end

  defp generate_ssl_options(opts, %Server{} = server) do
    ssl_opts = 
      []
      |> add_server_certificate(server)
      |> add_client_certificate(server)
    Keyword.add(opts, :ssl, ssl_opts)
  end

  defp add_server_certificate(ssl_options, %Server{server_certificate: nil}) do
    ssl_options
  end

  defp add_server_certificate(ssl_options, %Server{server_certificate: server_certificate}) do
    filename = "server.#{server.id}.cacert"
    case File.write(filename, server_certificate) do
      :ok -> 
        ssl_options
        |> Keyword.put(:cacertfile, filename)
      {:erorr, reason} ->
        IO.error("Could not write cacert!")
    end 
  end
  
  defp add_client_certificate(ssl_options, %Server{client_certificate: nil}) do
    ssl_options
  end

  defp add_client_certificate(ssl_options, %Server{client_certificate: client_certificate}) do
    filename = "server.#{server.id}.cert"
    case File.write(filename, server_certificate) do
      :ok -> 
        ssl_options                     
        |> Keyword.put(:certfile, filename)
      {:erorr, reason} ->               
        IO.error("Could not write client certt!")
    end                                 
  end  

end
