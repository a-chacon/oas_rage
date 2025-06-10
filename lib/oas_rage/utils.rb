# frozen_string_literal: true

module OasRage
  module Utils
    def self.camelize(str)
      str.split('_').map(&:capitalize).join
    end

    def self.safe_constantize(str)
      Object.const_get(str)
    rescue NameError
      nil
    end

    def self.constantize(str)
      Object.const_get(str)
    end
  end
end
