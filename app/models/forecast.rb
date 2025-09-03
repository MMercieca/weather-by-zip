class Forecast < ApplicationRecord
  belongs_to :zipcode, optional: true

  def self.for(zip)
    zipcode = Zipcode.from_code(zip)

    forecast = Forecast.where(zipcodes_id: zipcode.id).first

    if forecast.nil? || forecast.updated_at < 30.minutes.ago
      return get_current(zipcode)
    end

    forecast
  end

  def self.get_current(zipcode)
    OpenMetroForecast.current(zipcode: zipcode)
  end
end
