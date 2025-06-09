# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'debug'
require 'oas_rage'

require 'minitest/autorun'

ENV['RAGE_ENV'] ||= 'test'

require_relative '../test/dummy/config/environment'
