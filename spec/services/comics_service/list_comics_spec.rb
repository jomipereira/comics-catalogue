# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../app/services/comics_service/list_comics'
require_relative '../../../app/apis/marvel_api/v1/error'

RSpec.describe ComicsService::ListComics do
  subject(:list_comics) do
    described_class.new(
      client: api_client
    )
  end

  let(:api_client) { instance_double('MarvelAPI::V1::Client') }

  describe '#call' do
    context 'when comic_params is empty' do
      before do
        allow(api_client).to receive(:comics).with({ offset: 0 })
      end

      it 'calls client.comics with empty params' do
        list_comics.call
        expect(api_client).to have_received(:comics).with({ offset: 0 })
      end
    end

    context 'when comic_params has a term' do
      let(:comic_params) { { term: 'Iron Man' } }
      let(:characters_response) { { results: [{ id: 123 }] } }

      before do
        allow(api_client).to receive(:characters).with(name: 'Iron Man').and_return(characters_response)
        allow(api_client).to receive(:comics).with({ characters: 123, offset: 0 })
      end

      context 'when characters are found' do
        it 'calls client.comics with character_id and offset params' do
          list_comics.call(comic_params: comic_params)
          expect(api_client).to have_received(:comics).with({ characters: 123, offset: 0 })
        end
      end

      context 'when characters are not found' do
        let(:characters_response) { { results: [] } }

        before do
          allow(api_client).to receive(:characters).with(name: 'abcde').and_return(characters_response)
        end

        it 'raises an error' do
          expect do
            list_comics.call(comic_params: { term: 'abcde' })
          end.to raise_error(MarvelAPI::V1::Response::Error)
        end
      end
    end

    context 'when comic_params has a page' do
      let(:comic_params) { { page: 2 } }

      before do
        allow(api_client).to receive(:comics).with({ offset: 20 })
      end

      it 'calls client.comics with offset calculated from page' do
        list_comics.call(comic_params:)
        expect(api_client).to have_received(:comics).with({ offset: 20 })
      end
    end
  end
end
