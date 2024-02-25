# frozen_string_literal: true

require 'rails_helper'

require_relative '../../app/apis/marvel_api/v1/error'

RSpec.describe ComicsController, type: :controller do
  let(:api_client) { instance_double('MarvelAPI::V1::Client') }
  let!(:freeze_time) { Time.now }
  before do
    allow(MarvelAPI::V1::Client).to receive(:new).and_return(api_client)
  end

  describe 'GET #index' do
    describe 'when the request is successful' do
      before do
        allow(api_client).to receive(:comics).with({ offset: 0 }).and_return({ code: 200, data:
          {
            results: [
              {
                id: '5678',
                title: 'Avengers #1',
                thumbnail: {
                  path: 'http://i.annihil.us/u/prod/marvel/i/mgd/2/50/537bc703d31da',
                  extension: 'jpg'
                },
                characters: {
                  items: [
                    { name: 'Iron Man' },
                    { name: 'Captain America' }
                  ]
                }
              }
            ]
          } })
      end

      it 'returns a successful response' do
        get :index
        expect(response).to be_successful
      end

      it 'assigns @comics' do
        get :index
        expect(assigns(:comics)).not_to be_nil
      end
    end

    describe 'when the request is unsuccessful' do
      before do
        allow(api_client).to receive(:comics).with({ offset: 0 }).and_raise(MarvelAPI::V1::Response::Error.new({ code: 500, message: 'Internal Server Error' }))
      end

      it 'returns a 500 status' do
        get :index
        expect(response).to have_http_status(500)
      end

      it 'renders the error message' do
        get :index
        expect(response.body).to eq('500 Internal Server Error')
      end
    end
  end

  describe 'POST #set_favourite' do
    let(:api_client) { instance_double('MarvelAPI::V1::Client') }
    let!(:freeze_time) { Time.now }

    before do
      allow(MarvelAPI::V1::Client).to receive(:new).and_return(api_client)
    end

    context 'when the comic is successfully set as favorite' do
      let(:comic_params) { { comic: { comic_id: '22204', user_id: SecureRandom.uuid } } }

      before do
        allow(ComicsService::SetFavourite).to receive(:new).and_return(instance_double('ComicsService::SetFavourite', call: true))
      end

      it 'returns a successful response' do
        post :set_favourite, params: comic_params
        expect(response).to be_successful
      end
    end

    context 'when the comic fails to be set as favorite' do
      let(:set_favourite) { instance_double('ComicsService::SetFavourite') }
      let(:comic_params) { { comic: { comic_id: '22204' } } }
      let(:error_message) { 'Invalid comic' }

      before do
        allow(ComicsService::SetFavourite).to receive(:new).and_return(set_favourite)
        allow(set_favourite).to receive(:call).and_raise(ActiveRecord::RecordInvalid)
      end

      it 'returns a 422 status' do
        post :set_favourite, params: comic_params
        expect(response).to have_http_status(422)
      end
    end
  end
end
