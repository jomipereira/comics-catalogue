# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "comics/index", type: :view do
  let!(:freeze_time) { Time.now }
  let(:success_body) do
    {
      code: 200,
      etag: 'b87be4cce594ab089fcdf7da39665999dbcabc75',
      data: {
        offset: 1,
        limit: 1,
        page: 2,
        total: 3,
        count: 1,
        results: [
          {
            issn: '1234-5678',
            title: 'Marvel Previews (2017)',
            thumbnail: {
              path: 'http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available',
              extension: 'jpg'
            }
          }
        ]
      }
    }
  end
  let!(:request) do
    stub_request(:get, "#{MarvelAPI::V1::Client::BASE_URL}/comics?orderBy=-onsaleDate")
      .with(query:
        {
          ts: freeze_time,
          apikey: Rails.application.credentials.marvel[:public_key],
          hash: Digest::MD5.hexdigest(
            freeze_time.to_s +
            Rails.application.credentials.marvel[:private_key] +
            Rails.application.credentials.marvel[:public_key]
          )
        })
      .to_return(status: 200, body: success_body.to_json, headers: {})
  end

  before do
    assign(:comics, success_body[:data])
  end

  it 'renders the search input' do
    render

    assert_select 'form input[type=text][name=term]'
  end

  it 'renders the comic element' do
    render

    assert_select 'div.comic', count: 1
  end

  it 'renders the next page element' do
    render

    assert_select 'a', text: 'Next Page'
  end

  it 'renders the previous page element' do
    render

    assert_select 'a', text: 'Previous Page'
  end
end
