class Forecast < ApplicationRecord
  belongs_to :zip

  def self.for(zip)
    zipcode = Zipcode.from_code(zip)

    forecast = Forecast.where(zipcodes_id: zipcode.id).first

    if forecast.nil? || forecast.updated_at < 30.minutes.ago
      # TODOMPM - get new forecast
    end

    forecast
  end
end
