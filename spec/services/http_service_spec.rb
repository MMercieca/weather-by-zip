# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HttpService, type: :service do
  context 'happy path' do
    it 'creates' do
      described_class.new(url: 'https://www.example.com')
    end

    it 'defaults to GET' do
      http = described_class.new(url: 'https://www.example.com')

      expect(http.method).to eq('GET')
    end
  
    it 'does not require a body' do
      http = described_class.new(url: 'https://www.example.com')

      expect(http.body).to be_nil
    end
  end
end