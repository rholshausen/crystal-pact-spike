require "log"

module Pact::Crystal::Consumer::Dsl
  class PactBuilder
    def initialize(@consumer : String, @provider : String)
      @pact_handle = LibPactFfi.pactffi_new_pact(@consumer, @provider)
    end

    def finalize
      result = LibPactFfi.pactffi_free_pact_handle(@pact_handle)
      if result > 0
        Log.warn { "Failed to free Pact handle -> #{result}" }
      end
    end

    def http_interaction(description : String, &block : HttpInteractionBuilder -> Void) : PactBuilder
      interaction = HttpInteractionBuilder.new(@pact_handle, description)
      yield interaction
      self
    end

    def start_mock_server(address = "localhost", transport = "http") : MockServer
      mock_server = MockServer.new(@pact_handle, address, transport)
      mock_server
    end
  end

  class HttpInteractionBuilder
    def initialize(@pact_handle : LibPactFfi::PactHandle, @description : String)
      @interaction_handle = LibPactFfi.pactffi_new_interaction(@pact_handle, @description)
    end

    def given(state : String) : HttpInteractionBuilder
      if !LibPactFfi.pactffi_given(@interaction_handle, state)
        Log.warn { "Failed to add provider state to interaction" }
      end
      self
    end

    def with_request(method : String, path : String, &block : HttpRequestBuilder -> Void) : HttpInteractionBuilder
      request_builder = HttpRequestBuilder.new(@pact_handle, @interaction_handle, method, path)
      yield request_builder
      self
    end

    def will_response_with(&block : HttpResponseBuilder -> Void) : HttpInteractionBuilder
      response_builder = HttpResponseBuilder.new(@pact_handle, @interaction_handle)
      yield response_builder
      self
    end
  end

  class HttpRequestBuilder
    def initialize(@pact_handle : LibPactFfi::PactHandle, @interaction_handle : LibPactFfi::InteractionHandle, method : String, path : String)
      if !LibPactFfi.pactffi_with_request(@interaction_handle, method, path)
        Log.warn { "Failed to add new request to the interaction" }
      end
    end

    def header(name : String, value : String | Array(String)) : HttpRequestBuilder
      if value.is_a?(Array)
        # TODO
      else
        if !LibPactFfi.pactffi_with_header_v2(@interaction_handle, LibPactFfi::InteractionPart::Request, name, 0, value)
          Log.warn { "Failed to add header to the interaction" }
        end
      end
      self
    end

    def body(body : String, content_type : String? = nil) : HttpResponseBuilder
      if !LibPactFfi.pactffi_with_body(@interaction_handle, LibPactFfi::InteractionPart::Request, content_type, body)
        Log.warn { "Failed to set the response body for the interaction" }
      end
      self
    end
  end

  class HttpResponseBuilder
    def initialize(@pact_handle : LibPactFfi::PactHandle, @interaction_handle : LibPactFfi::InteractionHandle)
    end

    def status(status : UInt16) : HttpResponseBuilder
      if !LibPactFfi.pactffi_response_status(@interaction_handle, status)
        Log.warn { "Failed to set the response status for the interaction" }
      end
      self
    end

    def header(name : String, value : String | Array(String)) : HttpResponseBuilder
      if value.is_a?(Array)
        # TODO
      else
        if !LibPactFfi.pactffi_with_header_v2(@interaction_handle, LibPactFfi::InteractionPart::Response, name, 0, value)
          Log.warn { "Failed to add header to the interaction" }
        end
      end
      self
    end

    def body(body : String, content_type : String? = nil) : HttpResponseBuilder
      if !LibPactFfi.pactffi_with_body(@interaction_handle, LibPactFfi::InteractionPart::Response, content_type, body)
        Log.warn { "Failed to set the response body for the interaction" }
      end
      self
    end

    def json_body(body : Hash(String, Object)) : HttpResponseBuilder
      content_type = "application/json"
      body_str = Bodies.generate_json_body(body)
      if !LibPactFfi.pactffi_with_body(@interaction_handle, LibPactFfi::InteractionPart::Response, content_type, body_str)
        Log.warn { "Failed to set the response body for the interaction" }
      end
      self
    end
  end
end
