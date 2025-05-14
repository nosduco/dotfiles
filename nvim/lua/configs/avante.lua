local M = {}

M.opts = {
  provider = "openrouter",
  selector = {
    provider = "telescope",
  },
  cursor_applying_provider = "groq",
  behaviour = {
    enable_cursor_planning_mode = false,
    enable_claude_text_editor_tool_mode = true,
  },
  vendors = {
    openrouter = {
      __inherited_from = "openai",
      endpoint = "https://openrouter.ai/api/v1",
      api_key_name = "OPENROUTER_API_KEY",
      -- model = "google/gemini-2.5-pro-preview",
      model = "anthropic/claude-3.7-sonnet",
    },
    groq = {
      __inherited_from = "openai",
      endpoint = "https://api.groq.com/openai/v1/",
      api_key_name = "GROQ_API_KEY",
      model = "llama-3.3-70b-versatile",
      max_tokens = 32768,
    },
  },
  claude = {
    model = "claude-3-7-sonnet-20250219",
  },
  gemini = {
    model = "gemini-2.5-pro-exp-03-25",
  },
  rag_service = {
    enabled = false,
    host_mount = os.getenv "HOME",
    provider = "openai",
    llm_model = "",
    embed_model = "",
    endpoint = "https://api.openai.com/v1",
  },
  -- debug = true,
}

return M
