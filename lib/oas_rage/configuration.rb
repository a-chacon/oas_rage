# frozen_string_literal: true

module OasRage
  class Configuration < OasCore::Configuration
    attr_accessor :autodiscover_request_body, :autodiscover_responses, :ignored_actions, :rapidoc_theme, :layout
    attr_reader :route_extractor, :include_mode

    def initialize
      super
      @route_extractor = RouteExtractor
      @include_mode = :all
      @autodiscover_request_body = true
      @autodiscover_responses = true
      @ignored_actions = []
      @rapidoc_theme = :rails
      @layout = nil

      # TODO: implement
      # autodiscover_request_body
      # autodiscover_responses
    end

    def include_mode=(value)
      valid_modes = %i[all with_tags explicit]
      raise ArgumentError, "include_mode must be one of #{valid_modes}" unless valid_modes.include?(value)

      @include_mode = value
    end
  end
end
