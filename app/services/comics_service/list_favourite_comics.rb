# frozen_string_literal: true

module ComicsService
  class ListFavouriteComics
    def call(user_id:)
      FavouriteComic.where(user_id: user_id)
    end
  end
end
