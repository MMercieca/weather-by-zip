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

  context 'when posting' do
    it 'throws an exception' do
      expect { HttpService.new('https://www.example.com', method: 'POST') }.to raise_error(ArgumentError)
    end
  end

  context 'when getting' do
    let(:url) { 'https://www.example.com/' }
    let(:uri) { URI.parse(url) }
    let(:mock_http) { instance_double(Net::HTTP) }
    let(:mock_request) { instance_double(Net::HTTP::Get) }
    let(:body) { 'This is the body' }

    before do
      allow(Net::HTTP).to receive(:new).with(uri.host, uri.port).and_return(mock_http)
      allow(mock_http).to receive(:use_ssl=)
      allow(Net::HTTP::Get).to receive(:new).with(uri.request_uri).and_return(mock_request)
    end

    context 'when successful' do
      let(:mock_response) { instance_double(Net::HTTPResponse, body: body, code: "200") }

      before do
        allow(mock_http).to receive(:request).with(mock_request).and_return(mock_response)
        allow(mock_response).to receive(:code).and_return("200")
      end

      it 'returns the body when successful' do
        http = described_class.new(url: 'https://www.example.com')
        text = http.get

        expect(text).to eq(body)
      end
    end

    context 'with errors' do
      context 'when the document has moved' do
        let(:mock_response) { instance_double(Net::HTTPResponse, body: body, code: "301") }

        before do
          allow(mock_http).to receive(:request).with(mock_request).and_return(mock_response)
          allow(mock_response).to receive(:code).and_return("301")
        end

        it 'throws a CommunicationError' do
          expect { HttpService.new(url: 'https://www.example.com').get }.to raise_error(CommunicationError)
        end
      end

      context 'when there is an error using Net::HTTP' do
        before do
          allow(mock_http).to receive(:request).and_raise(Errno::ECONNREFUSED)
        end

        it 'throws a CommunicationError' do
          expect { HttpService.new(url: 'https://www.example.com').get }.to raise_error(CommunicationError)
        end
      end
    end
  end
end
