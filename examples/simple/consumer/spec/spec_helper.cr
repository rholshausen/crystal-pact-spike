require "spec"
require "log"
require "pact-crystal"
require "../src/consumer"

Log.setup_from_env
Pact::Crystal.init
