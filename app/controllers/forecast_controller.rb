class ForecastController < ApplicationController
  rescue_from ::CommunicationError, with: { redirect_to: "/communication_error" }

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

  def communication_error
  end

  def zip_from_params
    zip = params[:zip]

    begin
      @zipcode = Zipcode.from_code(zip)
    rescue ArgumentError
      zip = nil
    end

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
