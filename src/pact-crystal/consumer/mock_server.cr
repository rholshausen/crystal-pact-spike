require "log"
require "uri"

module Pact::Crystal::Consumer
  class MockServer
    def initialize(@pact_handle : LibPactFfi::PactHandle, @address : String, @transport : String)
      @mock_server_port = LibPactFfi.pactffi_create_mock_server_for_transport(@pact_handle, @address, 0, @transport, nil)
    end

    def finalize
      if !LibPactFfi.pactffi_cleanup_mock_server(@mock_server_port)
        Log.error { "Failed to shutdown mockserver with port #{@mock_server_port}" }
      end
    end


    def url
      URI.new("http", @address, @mock_server_port.to_i)
    end
  end
end
