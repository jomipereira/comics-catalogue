# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ComicsService::SetFavourite do
  describe '#call' do
    let(:comic_params) { { user_id: SecureRandom.uuid.to_s, comic_id: 1 } }

    it 'creates a new favourite comic' do
      expect {
        described_class.new.call(comic_params: comic_params)
      }.to change(FavouriteComic, :count).by(1)
    end

    it 'raises an error if the favourite comic creation fails' do
      allow(FavouriteComic).to receive(:create!).and_raise(ActiveRecord::RecordInvalid)

      expect {
        described_class.new.call(comic_params: comic_params)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
