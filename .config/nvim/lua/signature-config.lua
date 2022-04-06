local status_ok, signature = pcall(require, "lsp_signature")
if not status_ok then
  return
end


local config = {
  debug = false,
  verbose = false,
  hint_enable = true,
  use_lspsaga = false,
  hi_parameter = "LspSignatureActiveParameter",
  timer_interval = 200,
}

signature.setup(config)
signature.on_attach(config)
