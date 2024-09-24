defmodule Dispatcher do
  use Matcher
  define_accept_types [
    html: [ "text/html", "application/xhtml+html" ],
    json: [ "application/json", "application/vnd.api+json" ]
  ]

  @any %{}

  define_layers [ :static, :services, :fall_back, :not_found ]

  # In order to forward the 'themes' resource to the
  # resource service, use the following forward rule:
  #
  # match "/themes/*path", @json do
  #   Proxy.forward conn, path, "http://resource/themes/"
  # end
  #
  # Run `docker-compose restart dispatcher` after updating
  # this file.

  ###############
  # RESOURCES
  ###############


  match "/address-representations/*path", %{ layer: :services, json: true } do
    Proxy.forward conn, path, "http://resource/address-representations/"
  end

  match "/cases/*path", %{ layer: :services, json: true } do
    Proxy.forward conn, path, "http://resource/cases/"
  end

  match "/designation-objects/*path", %{ layer: :services, json: true } do
    Proxy.forward conn, path, "http://resource/designation-objects/"
  end

  match "/postal-items/*path", %{ layer: :services, json: true } do
    Proxy.forward conn, path, "http://resource/postal-items/"
  end

  ###############################################################
  # frontend layer
  ###############################################################
  match "/assets/*path", %{ layer: :static } do
    Proxy.forward conn, path, "http://frontend/assets/"
  end

  match "/@appuniversum/*path", %{ layer: :static } do
    Proxy.forward conn, path, "http://frontend/@appuniversum/"
  end

  match "/*path", %{ accept: %{html: true}, layer: :static } do
    Proxy.forward conn, [], "http://frontend/index.html"
  end

  match "/*_path", %{ layer: :static } do
    Proxy.forward conn, [], "http://frontend/index.html"
  end


  #
  # Run `docker-compose restart dispatcher` after updating
  # this file.

  match "/*_", %{ layer: :not_found } do
    send_resp( conn, 404, "Route not found.  See config/dispatcher.ex" )
  end

  match "/*_", %{ layer: :not_found } do
    send_resp( conn, 404, "Route not found.  See config/dispatcher.ex" )
  end
end
