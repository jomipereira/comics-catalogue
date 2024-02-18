# frozen_string_literal: true

module MarvelAPI
  module V1
    module Response
      class Error < StandardError
        attr_reader :code, :status

        def initialize(response)
          super()
          @code = response[:code]
          @status = response[:status] || response[:message]
        end

        def to_s
          "#{@code} #{@status}"
        end
      end
    end
  end
end
