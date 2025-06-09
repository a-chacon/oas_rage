# frozen_string_literal: true

require 'rack'
require 'oas_core'

OasCore.configure_yard!

module OasRage
  autoload :VERSION, 'oas_rage/version'
  autoload :Configuration, 'oas_rage/configuration'
  autoload :RouteExtractor, 'oas_rage/route_extractor'
  autoload :OasRouteBuilder, 'oas_rage/oas_route_builder'
  autoload :Utils, 'oas_rage/utils'

  module Web
    autoload :View, 'oas_rage/web/view'
  end

  class << self
    def build
      OasCore.config = config

      host_routes = RouteExtractor.new.host_routes
      oas = OasCore::Builders::SpecificationBuilder.new.with_oas_routes(host_routes).build

      oas.to_spec
    end

    def configure
      yield config
    end

    def config
      @config ||= Configuration.new
    end
  end
end
