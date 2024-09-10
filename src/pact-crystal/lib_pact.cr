module Pact::Crystal
  @[Link(ldflags: "-Wl,-rpath,#{__DIR__}/../../ext -L#{__DIR__}/../../ext")]
  @[Link("pact_ffi")]
  lib LibPactFfi
    fun pactffi_version: UInt8*
    fun pactffi_init(log_env_var: UInt8*)
  end
end
