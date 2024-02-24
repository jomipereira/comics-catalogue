class FavouriteComic < ApplicationRecord
  validates :comic_id, presence: true
  validates :user_id, presence: true
end
