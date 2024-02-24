# frozen_string_literal: true

require 'spec_helper'

require_relative '../../../../app/apis/marvel_api/v1/response'

RSpec.describe MarvelAPI::V1::Response do
  subject { described_class.create(data:, entity:) }

  let(:data) do
    {
      count: 1,
      limit: 1,
      page: 1,
      offset: 0,
      total: 1,
      results:
    }
  end

  describe 'when entity is comic' do
    let(:entity) { :comic }
    let(:results) do
      [
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
    end

    describe '.create' do
      it 'transforms the data into a desired format' do
        expect(subject).to eq(
          {
            count: 1,
            limit: 1,
            page: 1,
            offset: 0,
            total: 1,
            results: [
              {
                id: '5678',
                title: 'Avengers #1',
                thumbnail: 'http://i.annihil.us/u/prod/marvel/i/mgd/2/50/537bc703d31da/portrait_incredible.jpg'
              }
            ]
          }
        )
      end

      it 'uses the predefined IMAGE_SIZE for thumbnail urls' do
        expect(subject[:results].first[:thumbnail]).to include(MarvelAPI::V1::Response::IMAGE_SIZE)
      end
    end
  end

  describe 'when entity is character' do
    let(:entity) { :character }
    let(:results) do
      [
        {
          id: 1011334,
          name: 'Deadpool'
        }
      ]
    end

    describe '.create' do
      it 'transforms the data into a desired format' do
        expect(subject).to eq(
          {
            count: 1,
            limit: 1,
            page: 1,
            offset: 0,
            total: 1,
            results: [
              {
                id: 1011334,
                name: 'Deadpool'
              }
            ]
          }
        )
      end
    end
  end
end
