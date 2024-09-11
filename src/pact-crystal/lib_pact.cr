module Pact::Crystal
  @[Link(ldflags: "-Wl,-rpath,#{__DIR__}/../../ext -L#{__DIR__}/../../ext")]
  @[Link("pact_ffi")]
  lib LibPactFfi
    fun pactffi_version: UInt8*
    fun pactffi_init(log_env_var: UInt8*)
    fun pactffi_init_with_log_level(level: UInt8*)
    fun pactffi_log_message(source: UInt8*, log_level: UInt8*, message: UInt8*)

    type PactHandle = UInt16
    type InteractionHandle = UInt32

    enum InteractionPart
      Request = 0
      Response = 1
    end

    fun pactffi_new_pact(consumer_name: UInt8*, provider_name: UInt8*) : PactHandle
    fun pactffi_free_pact_handle(handle: PactHandle) : UInt32

    fun pactffi_new_interaction(pact: PactHandle, description: UInt8*) : InteractionHandle
    fun pactffi_given(interaction: InteractionHandle, description: UInt8*) : Bool
    fun pactffi_with_request(
        interaction: InteractionHandle,
        method: UInt8*,
        path: UInt8*
    ) : Bool
    fun pactffi_with_header_v2(
        interaction: InteractionHandle,
        part: InteractionPart,
        name: UInt8*,
        index: LibC::ULong,
        value: UInt8*
    ) : Bool
    fun pactffi_with_body(
        interaction: InteractionHandle,
        part: InteractionPart,
        content_type: UInt8*,
        body: UInt8*
    ) : Bool
    fun pactffi_response_status(interaction: InteractionHandle, status: LibC::UShort) : Bool

    fun pactffi_create_mock_server_for_transport(
        pact: PactHandle,
        addr: UInt8*,
        port: UInt16,
        transport: UInt8*,
        transport_config: UInt8*
    ) : UInt32
    fun pactffi_cleanup_mock_server(mock_server_port: Int32) : Bool
  end
end
