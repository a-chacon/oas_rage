# frozen_string_literal: true

module OasRage
  class RouteExtractor
    def initialize
      @host_routes = nil
      @host_paths = nil
    end

    def host_routes_by_path(path)
      host_routes.select { |r| r.path == path }
    end

    def host_routes
      @host_routes ||= extract_host_routes
    end

    # Clear instance variable @host_routes
    #
    # This method clears the instance variable @host_routes
    # to force a re-extraction of the routes.
    def clear_cache
      @host_routes = nil
      @host_paths = nil
    end

    def host_paths
      @host_paths ||= host_routes.map(&:path).uniq.sort
    end

    private

    def extract_host_routes
      routes = valid_routes.map { |r| OasRouteBuilder.build_from_rage_route(r) }
      routes.select! { |route| route.tags.any? } if OasRage.config.include_mode == :with_tags
      if OasRage.config.include_mode == :explicit
        routes.select! do |route|
          route.tags.any? do |t|
            t.tag_name == 'oas_include'
          end
        end
      end
      routes
    end

    def valid_routes
      Rage.__router.routes.select do |route|
        valid_api_route?(route)
      end
    end

    def valid_api_route?(route)
      return false unless valid_route_implementation?(route)
      # return false unless route.path.spec.to_s.start_with?(OasRage.config.api_path)
      return false if ignore_custom_actions(route)

      true
    end

    # Checks if a route has a valid implementation.
    #
    # This method verifies that both the controller and the action specified
    # in the route exist. It checks if the controller class is defined and
    # if the action method is implemented within that controller.
    #
    # @param route [ActionDispatch::Journey::Route] The route to check.
    # @return [Boolean] true if both the controller and action exist, false otherwise.
    def valid_route_implementation?(route)
      raw_handler = route[:meta][:raw_handler]
      return false unless raw_handler.is_a?(String) && raw_handler.include?('#')

      controller_name, action_name = raw_handler.split('#')
      controller_name = "#{Utils.camelize(controller_name)}Controller"

      controller_class = Utils.safe_constantize(controller_name)
      return false unless controller_class

      controller_class.instance_methods.include?(action_name.to_sym)
    end

    # Ignore user-specified paths in initializer configuration.
    # Sanitize api_path by removing the "/" if it starts with that, and adding "/" if it ends without that.
    # Support controller name only to ignore all controller actions.
    # Support ignoring "controller#action"
    # Ignoring "controller#action" AND "api_path/controller#action"
    def ignore_custom_actions(route)
      api_path = "#{OasRage.config.api_path.sub(%r{\A/}, '')}/".sub(%r{/+$}, '/')
      ignored_actions = OasRage.config.ignored_actions.flat_map do |custom_route|
        if custom_route.start_with?(api_path)
          [custom_route]
        else
          ["#{api_path}#{custom_route}", custom_route]
        end
      end

      raw_handler = route[:meta][:raw_handler]
      return false unless raw_handler.is_a?(String) && raw_handler.include?('#')

      controller_action = raw_handler
      controller_only = raw_handler.split('#').first

      ignored_actions.include?(controller_action) || ignored_actions.include?(controller_only)
    end
  end
end
