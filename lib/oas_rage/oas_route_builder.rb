# frozen_string_literal: true

module OasRage
  class OasRouteBuilder
    def self.build_from_rage_route(rage_route)
      new(rage_route).build
    end

    def initialize(rage_route)
      @rage_route = rage_route
    end

    def build
      OasCore::OasRoute.new(
        controller_class: controller_class,
        controller_action: controller_action,
        controller: controller,
        method_name: method,
        verb: verb,
        path: path,
        docstring: docstring,
        source_string: source_string,
        tags: tags
      )
    end

    private

    def controller_class
      controller_name = @rage_route[:meta][:raw_handler].split('#').first
      "#{Utils.camelize(controller_name)}Controller"
    end

    def controller_action
      "#{controller_class}##{@rage_route[:meta][:raw_handler].split('#').last}"
    end

    def controller
      @rage_route[:meta][:raw_handler].split('#').first
    end

    def method
      @rage_route[:meta][:raw_handler].split('#').last
    end

    def verb
      @rage_route[:method]
    end

    def path
      @rage_route[:path].to_s.gsub('(.:format)', '').gsub(/:\w+/) { |match| "{#{match[1..]}}" }
    end

    def source_string
      Utils.constantize(controller_class).instance_method(method).source
    end

    def docstring
      comment_lines = Utils.constantize(controller_class).instance_method(method).comment.lines
      processed_lines = comment_lines.map { |line| line.sub(/^# /, '') }
      ::YARD::Docstring.parser.parse(processed_lines.join).to_docstring
    end

    def tags
      method_comment = Utils.constantize(controller_class).instance_method(method).comment
      class_comment = Utils.constantize(controller_class).instance_method(method).class_comment

      method_tags = parse_tags(method_comment)
      class_tags = parse_tags(class_comment)

      method_tags + class_tags
    end

    def parse_tags(comment)
      lines = comment.lines.map { |line| line.sub(/^# /, '') }
      ::YARD::Docstring.parser.parse(lines.join).tags
    end
  end
end
