defmodule Dispatcher do
  use Matcher
  define_accept_types [
    html: [ "text/html", "application/xhtml+html" ],
    json: [ "application/json", "application/vnd.api+json" ]
  ]

  @any %{}
  @json %{ accept: %{ json: true } }
  @html %{ accept: %{ html: true } }

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


  match "/address-representations/*path", @json do
    Proxy.forward conn, path, "http://resource/address-representations/"
  end

  match "/cases/*path", @json do
    Proxy.forward conn, path, "http://resource/cases/"
  end

  match "/designation-objects/*path", @json do
    Proxy.forward conn, path, "http://resource/designation-objects/"
  end

  match "/postal-items/*path", @json do
    Proxy.forward conn, path, "http://resource/postal-items/"
  end

  match "/decision-info/*path", @json do
    Proxy.forward conn, path, "http://decision-info/"
  end

  match "/llm/*path", @json do
    Proxy.forward conn, path, "http://llm/"
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
