# frozen_string_literal: true

module ComicsService
  class SetFavourite
    def call(comic_params:)
      FavouriteComic.find_or_create_by!(comic_params)
    rescue ActiveRecord::RecordInvalid => e
      raise e
    end
  end
end
