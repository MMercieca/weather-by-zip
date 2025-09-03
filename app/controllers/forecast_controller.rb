class ForecastController < ApplicationController
  def default
    @zip = "49503"
    @zipcode = Zipcode.from_code(@zip)
    @forecast = Forecast.for(@zip)
  end

  def show
    @zip = zip_from_params
    @zipcode = Zipcode.from_code(@zip)
    @forecast = Forecast.for(@zip)
  end

  def zip_from_params
    zip = params[:zip]

    if !zip || !is_number?(zip) || zip.length > 5
      zip = '49503'
      flash[:error] = I18n.t("zipcode.not_found")
    end

    return zip
  end

  def is_number?(s)
    s.gsub(/[^0-9]/,'') == s
  end
end
