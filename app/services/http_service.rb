# frozen_string_literal: true

class HttpService
  def initialize(url:, method: 'GET', body: nil)
    parse_uri(url)
    raise ArgumentError, I18n.t("http_service.invalid_url") if @port.nil? || @host.nil? || @scheme.nil?

    @method = method
    @body = nil
  end

  def method
    @method
  end

  def body
    @body
  end

  def parse_uri(url)
    @uri = URI.parse(url)
    @port = @uri.port
    @host = @uri.host
    @path = @uri.path
    @scheme = @uri.scheme
  end

  def exec
    return get if method == "GET"

    raise NotImplementedError
  end
end
