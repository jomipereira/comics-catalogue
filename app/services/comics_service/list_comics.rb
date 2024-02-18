# frozen_string_literal: true

module ComicsService
  class ListComics
    def initialize(client: MarvelAPI::V1::Client.new)
      @client = client
    end

    def call(comic_params: {})
      client.comics(params(comic_params:))
    rescue MarvelAPI::V1::Response::Error => e
      raise e
    end

    private

    attr_reader :client

    def params(comic_params: {})
      params = {}
      if comic_params[:term]
        characters = client.characters(name: comic_params[:term])
        if characters[:results].empty?
          raise MarvelAPI::V1::Response::Error.new({ code: 404, message: 'Character not found' })
        end

        params[:characters] = characters[:results].first[:id]
      end

      params[:offset] = comic_params[:page] && (comic_params[:page].to_i - 1) * 20 || 0

      params
    end
  end
end
