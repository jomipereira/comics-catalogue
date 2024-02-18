# frozen_string_literal: true

class ComicsController < ApplicationController
  def index
    @comics = ComicsService::ListComics.new.call(comic_params:)
  rescue MarvelAPI::V1::Response::Error => e
    render status: e.code, body: e.message
  end

  private

  def comic_params
    params.permit(:term, :page, :per_page)
  end
end
