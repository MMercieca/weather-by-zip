class OpenMetroForecast
  def self.current(zipcode:)
    http = HttpService.new(url: url(zipcode.lat, zipcode.long))
    data = http.run

    return forecast_from_raw(zipcode, data)
  end

  # How did I get this? I went to an example from the docs.  The raw data is JSON
  # Defaulting to Farenheit.  We're talking about zipcodes so this seems to be US based.
  # So also using imperial units, but we'll translate for storage.
  def self.url(lat, long)
    return "https://api.open-meteo.com/v1/forecast?latitude=#{lat}&longitude=#{long}&daily=temperature_2m_max,temperature_2m_min&hourly=temperature_2m&current=temperature_2m,relative_humidity_2m,precipitation,apparent_temperature&wind_speed_unit=mph&temperature_unit=fahrenheit&precipitation_unit=inch"
  end

  def self.forecast_from_raw(zipcode, data)
    parsed = JSON.parse(data)

    forecast = Forecast.where(zipcodes_id: zipcode.id).first

    if forecast.nil?
      forecast = Forecast.create!(zipcodes_id: zipcode.id)
    end

    forecast.update!(raw_data: data,
                    service: "open-metro",
                    farenheit: parsed["current"]["temperature_2m"],
                    farenheit_high: parsed["daily"]["temperature_2m_max"].max,
                    farenheit_low: parsed["daily"]["temperature_2m_min"].min,
                    celcius: celcius_from_farenheit(parsed["current"]["temperature_2m"]),
                    celcius_high: celcius_from_farenheit(parsed["daily"]["temperature_2m_max"].max),
                    celcius_low: celcius_from_farenheit(parsed["daily"]["temperature_2m_min"].min)
                    )
    forecast
  end

  def self.celcius_from_farenheit(farenheit)
    temp = farenheit.to_f
    ((temp - 32) * 5/9).round(1)
  end
end