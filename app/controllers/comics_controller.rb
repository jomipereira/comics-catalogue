# frozen_string_literal: true

class ComicsController < ApplicationController
  def index
    @comics = ComicsService::ListComics.new.call(comic_params: index_params, user_id: cookies[:user_id])
  rescue MarvelAPI::V1::Response::Error => e
    render status: e.code, body: e.message
  end

  def set_favourite
    @favourite = ComicsService::SetFavourite.new.call(comic_params:)
  rescue ActiveRecord::RecordInvalid => e
    render status: 422, body: 'Invalid comic'
  end

  private

  def index_params
    params.permit(:term, :page, :per_page)
  end

  def comic_params
    params.require(:comic).permit(:comic_id, :user_id)
  end
end
