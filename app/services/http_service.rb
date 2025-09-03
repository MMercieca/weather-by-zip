# frozen_string_literal: true

class HttpService
  attr_accessor :method, :body, :host, :port, :uri, :scheme

  def initialize(url:, method: "GET", body: nil)
    parse_uri(url)
    raise ArgumentError, I18n.t("http_service.invalid_url") if @port.nil? || @host.nil? || @scheme.nil?
    rails ArgumentError, I18n.t("http_service.invalid_url") if @scheme != "http" && @scheme != "https"

    @method = method
    @body = nil
  end

  def parse_uri(url)
    @uri = URI.parse(url)
    @port = @uri.port
    @host = @uri.host
    @path = @uri.path
    @scheme = @uri.scheme
  end

  def run
    return method_get if method == "GET"

    raise NotImplementedError
  end

  def method_get
    http = Net::HTTP.new(host, port)
    http.use_ssl = (scheme == "https")

    request = Net::HTTP::Get.new(uri.request_uri)

    begin
      response = http.request(request)
      return response.body if response.code == "200"
    rescue
      # We could be better about this later but time is short.  For this project it really doesn't matter
      # why we can't reach the weather service, just that we can't.
    end

    raise CommunicationError
  end
end
