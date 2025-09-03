class Zipcode < ApplicationRecord
  def self.from_code(zip)
    zip = Zipcode.where(zip: zip).first

    if !zip
      # TODOMPM - geocode this
    end

    return zip
  end
end
