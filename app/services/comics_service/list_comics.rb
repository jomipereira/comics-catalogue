# frozen_string_literal: true

module ComicsService
  class ListComics
    def initialize(client: MarvelAPI::V1::Client.new)
      @client = client
    end

    def call(comic_params: {}, user_id: nil)
      api_comics = client.comics(params(comic_params:))

      return api_comics unless user_id

      favourite_comics = ListFavouriteComics.new.call(user_id:)

      return api_comics if favourite_comics.empty?

      favourite_comics_ids = favourite_comics.map(&:comic_id)

      api_comics[:results].each do |comic|
        comic[:favourite] = favourite_comics_ids.include?(comic[:id].to_s)
      end

      api_comics
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
