# frozen_string_literal: true

require 'bundler/setup'
require 'rage'
require 'oas_rage'
require 'debug'

require 'rage/all'

Rage.configure do
  # use this to add settings that are constant across all environments
end

# Mock the root method of the Rage framework
module Rage
  def self.root
    Pathname.new(File.expand_path('../../../test/dummy', __dir__))
  end
end

require 'rage/setup'
