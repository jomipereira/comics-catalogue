# frozen_string_literal: true

require 'spec_helper'

require_relative '../../../../app/apis/marvel_api/v1/error'

RSpec.describe MarvelAPI::V1::Response::Error do
  let(:response) { { code: 404, status: 'Not Found' } }

  subject { MarvelAPI::V1::Response::Error.new(response) }

  it 'inherits from StandardError' do
    expect(MarvelAPI::V1::Response::Error).to be < StandardError
  end

  it 'reads code and status from response' do
    expect(subject.code).to eq(404)
    expect(subject.status).to eq('Not Found')
  end

  it 'provides a formatted error message' do
    expect(subject.to_s).to eq('404 Not Found')
  end
end
