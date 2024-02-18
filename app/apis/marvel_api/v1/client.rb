# frozen_string_literal: true

require_relative 'response'
require_relative 'error'

module MarvelAPI
  module V1
    class Client
      BASE_URL = 'http://gateway.marvel.com/v1/public'

      def initialize
        @client = ::Faraday.new(BASE_URL) do |client|
          client.request :url_encoded
          client.adapter Faraday.default_adapter
        end
      end

      def comics(params = {})
        request(
          entity: :comic,
          http_method: :get,
          endpoint: 'comics',
          params: { orderBy: '-onsaleDate' }.merge(params)
        )
      end

      def characters(name: nil)
        request(
          entity: :character,
          http_method: :get,
          endpoint: 'characters',
          params: name ? { name: } : {}
        )
      end

      private

      def request(entity:, http_method:, endpoint:, params: {})
        etag = params.delete(:etag)
        response = client.send(http_method) do |request|
          request.url(endpoint, params.merge(hash))
          request.headers['If-None-Match'] = etag if etag
        end

        handle_response(entity:, body: Oj.load(response.body, symbol_keys: true))
      end

      def handle_response(entity:, body:)
        case body[:code]
        when 200 then Response.create(entity:, data: body[:data])
        else Response::Error.new(body)
        end
      end

      def hash
        timestamp = Time.now.to_s
        private_key = Rails.application.credentials.marvel[:private_key]
        api_key = Rails.application.credentials.marvel[:public_key]

        {
          ts: timestamp,
          apikey: api_key,
          hash: Digest::MD5.hexdigest(timestamp + private_key + api_key)
        }
      end

      attr_reader :client
    end
  end
end
