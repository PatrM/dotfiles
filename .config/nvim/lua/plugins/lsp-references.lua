-- Group `gr` references by file (via Trouble) and drop import-statement hits.
-- Import detection is treesitter-based so multi-line imports are caught too.
local function in_import(item)
  local buf = item.buf
  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    return false
  end
  pcall(vim.fn.bufload, buf)
  local ft = vim.bo[buf].filetype
  if ft ~= "typescript" and ft ~= "typescriptreact" and ft ~= "javascript" and ft ~= "javascriptreact" then
    return false
  end
  local pos = item.pos or { 1, 0 }
  local ok, node = pcall(vim.treesitter.get_node, { bufnr = buf, pos = { pos[1] - 1, pos[2] } })
  if not ok or not node then
    return false
  end
  while node do
    if node:type() == "import_statement" then
      return true
    end
    node = node:parent()
  end
  return false
end

return {
  {
    "folke/trouble.nvim",
    opts = {
      modes = {
        lsp_references_noimports = {
          mode = "lsp_references",
          desc = "References (no imports)",
          filter = { function(item) return not in_import(item) end },
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          -- stylua: ignore
          keys = {
            { "gr", "<cmd>Trouble lsp_references_noimports toggle focus=true<cr>", desc = "References (no imports)", nowait = true },
            { "gR", "<cmd>Trouble lsp_references toggle focus=true<cr>", desc = "References (all, incl. imports)", nowait = true },
          },
        },
      },
    },
  },
}
