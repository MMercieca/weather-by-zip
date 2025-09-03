class Zipcode < ApplicationRecord
  def self.from_code(zip)
    zip = Zipcode.where(zip: zip).first

    if !zip
      raise ArgumentError, I18n.t("zipcode.not_found")
    end

    return zip
  end
end
