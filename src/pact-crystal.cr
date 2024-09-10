require "./pact-crystal/*"
require "log"

module Pact::Crystal
  extend self

  VERSION = {{ `shards version "#{__DIR__}"`.chomp.stringify.downcase }}

  def init
    version = String.new(LibPactFfi.pactffi_version)
    Log.info { "Pact Crystal version: #{VERSION}" }
    Log.info { "--> Pact FFI version: #{version}" }

    LibPactFfi.pactffi_init("LOG_LEVEL")
  end
end
