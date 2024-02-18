# frozen_string_literal: true

require 'rails_helper'

require_relative '../../../../app/apis/marvel_api/v1/client'
require_relative '../../../../app/apis/marvel_api/v1/error'

RSpec.describe MarvelAPI::V1::Client do
  subject { described_class.new }

  describe '#comics' do
    let!(:freeze_time) { Time.now }
    let(:success_body) do
      {
        code: 200,
        etag: 'b87be4cce594ab089fcdf7da39665999dbcabc75',
        data: {
          offset: 0,
          limit: 1,
          page: 1,
          total: 1,
          count: 1,
          results: [
            {
              issn: '1234-5678',
              title: 'Marvel Previews (2017)',
              thumbnail: {
                path: 'http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available',
                extension: 'jpg'
              }
            }
          ]
        }
      }
    end
    let!(:request) do
      stub_request(:get, "#{MarvelAPI::V1::Client::BASE_URL}/comics?orderBy=-onsaleDate")
        .with(query:
          {
            ts: freeze_time,
            apikey: Rails.application.credentials.marvel[:public_key],
            hash: Digest::MD5.hexdigest(
              freeze_time.to_s +
              Rails.application.credentials.marvel[:private_key] +
              Rails.application.credentials.marvel[:public_key]
            )
          })
    end

    describe 'when the request is successful' do
      before do
        request.to_return(status: 200, body: success_body.to_json)
      end

      it 'sends a get request' do
        subject.comics
        expect(request).to have_been_made
      end

      it 'returns a Response instance with the parsed results data' do
        expect(subject.comics).to eq(
          {
            offset: 0,
            limit: 1,
            page: 1,
            total: 1,
            count: 1,
            results: [
              {
                issn: '1234-5678',
                title: 'Marvel Previews (2017)',
                thumbnail: 'http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available/portrait_incredible.jpg'
              }
            ]
          }
        )
      end
    end

    describe 'when the request is unsuccessful' do
      let(:error_body) do
        {
          code: 404,
          status: 'Resource not found'
        }
      end

      before do
        request.to_return(status: 404, body: error_body.to_json)
      end

      it 'returns a Response::Error instance' do
        expect(subject.comics).to be_a(MarvelAPI::V1::Response::Error)
      end
    end
  end

  describe '#characters' do
    let!(:freeze_time) { Time.now }
    let(:success_body) do
      {
        code: 200,
        etag: 'b87be4cce594ab089fcdf7da39665999dbcabc75',
        data: {
          offset: 0,
          page: 1,
          limit: 1,
          total: 1,
          count: 1,
          results: [
            {
              id: 1011334,
              name: 'Deadpool'
            }
          ]
        }
      }
    end
    let!(:request) do
      stub_request(:get, "#{MarvelAPI::V1::Client::BASE_URL}/characters?name=Deadpool")
        .with(query:
          {
            ts: freeze_time,
            apikey: Rails.application.credentials.marvel[:public_key],
            hash: Digest::MD5.hexdigest(
              freeze_time.to_s +
              Rails.application.credentials.marvel[:private_key] +
              Rails.application.credentials.marvel[:public_key]
            )
          })
    end

    describe 'when the request is successful' do
      before do
        request.to_return(status: 200, body: success_body.to_json)
      end

      it 'sends a get request' do
        subject.characters(name: 'Deadpool')
        expect(request).to have_been_made
      end

      it 'returns a Response instance with the parsed results data' do
        expect(subject.characters(name: 'Deadpool')).to eq(
          {
            offset: 0,
            limit: 1,
            page: 1,
            total: 1,
            count: 1,
            results: [
              {
                id: 1011334,
                name: 'Deadpool'
              }
            ]
          }
        )
      end
    end

    describe 'when the request is unsuccessful' do
      let(:error_body) do
        {
          code: 404,
          status: 'Resource not found'
        }
      end

      before do
        request.to_return(status: 404, body: error_body.to_json)
      end

      it 'returns a Response::Error instance' do
        expect(subject.characters(name: 'Deadpool')).to be_a(MarvelAPI::V1::Response::Error)
      end
    end
  end
end
