# frozen_string_literal: true

class CommunicationError < StandardError; end

class HttpService
  def initialize(url:, method: "GET", body: nil)
    parse_uri(url)
    raise ArgumentError, I18n.t("http_service.invalid_url") if @port.nil? || @host.nil? || @scheme.nil?
    rails ArgumentError, I18n.t("http_service.invalid_url") if @scheme != "http" && @scheme != "https"

    @method = method
    @body = nil
  end

  def method
    @method
  end

  def body
    @body
  end

  def host
    @host
  end

  def port
    @port
  end

  def uri
    @uri
  end

  def scheme
    @scheme
  end

  def parse_uri(url)
    @uri = URI.parse(url)
    @port = @uri.port
    @host = @uri.host
    @path = @uri.path
    @scheme = @uri.scheme
  end

  def get
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

  def exec
    return get if method == "GET"

    raise NotImplementedError
  end
end
