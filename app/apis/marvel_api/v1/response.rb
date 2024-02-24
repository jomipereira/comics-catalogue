# frozen_string_literal: true

module MarvelAPI
  module V1
    module Response
      IMAGE_SIZE = 'portrait_incredible'

      def self.create(data:, entity:)
        {
          offset: data[:offset],
          page: data[:offset] / data[:limit] + 1,
          limit: data[:limit],
          total: data[:total],
          count: data[:count],
          results: data[:results].map { |result| send("#{entity}_response", result) }
        }
      end

      def self.comic_response(comic)
        {
          id: comic[:id],
          title: comic[:title],
          thumbnail: "#{comic[:thumbnail][:path]}/#{IMAGE_SIZE}.#{comic[:thumbnail][:extension]}"
        }
      end

      def self.character_response(character)
        {
          name: character[:name],
          id: character[:id]
        }
      end
    end
  end
end
