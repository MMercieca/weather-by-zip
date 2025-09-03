# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Forecast, type: :model do
  it 'creates' do
    Forecast.new
  end

  context 'with zipcodes' do
    let!(:zip) { Zipcode.create!(zip: '12345', lat: '1', long: '1', locality: 'Locality') }

    before do
      allow(Forecast).to receive(:get_current)
    end

    it 'will update if the forecast does not exist' do
      Forecast.for('12345')
      
      expect(Forecast).to have_received(:get_current)
    end

    it 'will update when a forecast is more than 30 minutes old' do
      Forecast.create!(zipcodes_id: zip.id, updated_at: 31.minutes.ago)
      Forecast.for('12345')

      expect(Forecast).to have_received(:get_current)
    end

    it 'will not update a recent forecast' do
      f = Forecast.create!(zipcodes_id: zip.id, updated_at: 1.minute.ago)
      Forecast.for('12345')

      expect(Forecast).not_to have_received(:get_current)
    end
  end
end