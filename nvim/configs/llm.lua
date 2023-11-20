local M = {}

M.opts = {
  api_token = nil,
  tokens_to_clear = { "<EOT> "},
  fim = {
    enabled = true,
    prefix = "<PRE> ",
    middle = " <MID>",
    suffix = " <SUF>",
  },
  model = "codellama/CodeLlama-13b-hf",
  context_window = 4096,
  tokenizer = {
    repository = "codellama/CodeLlama-13b-hf",
  },
  accept_keymap = "<c-g>",
  dismiss_keymap = "<c-x>"
}

return M
