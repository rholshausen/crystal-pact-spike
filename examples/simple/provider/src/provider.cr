require "http/server"
require "log"
require "log/json"

module Provider
  VERSION = "0.1.0"
end

Log.setup_from_env

server = HTTP::Server.new do |context|
  context.response.content_type = "text/plain"
  context.response.print "Hello world! The time is #{Time.local}"
end

address = server.bind_tcp 8080
Log.info &.emit("Listening on http://#{address}", port: 8080)
server.listen
