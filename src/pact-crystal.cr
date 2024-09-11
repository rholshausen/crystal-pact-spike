require "./pact-crystal/*"
require "log"

module Pact::Crystal
  extend self

  VERSION = {{ `shards version "#{__DIR__}"`.chomp.stringify.downcase }}

  def init
    log = Log.for(Pact::Crystal)

    version = String.new(LibPactFfi.pactffi_version)
    log.debug { "Pact Crystal version: #{VERSION}" }
    log.debug { "--> Pact FFI version: #{version}" }

    LibPactFfi.pactffi_init_with_log_level(log.level.to_s.upcase)
    LibPactFfi.pactffi_log_message("pact.crystal", "DEBUG", "Logging initialised")
  end
end
