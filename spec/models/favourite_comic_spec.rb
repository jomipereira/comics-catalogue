require 'rails_helper'

RSpec.describe FavouriteComic, type: :model do
  it { is_expected.to validate_presence_of(:comic_id) }
  it { is_expected.to validate_presence_of(:user_id) }
end
