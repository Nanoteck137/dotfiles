local function tab2(bufnr)
  vim.bo[bufnr].tabstop = 2
  vim.bo[bufnr].shiftwidth = 2
end


local filetype_opts = {
  lua = tab2,
  html = tab2,
  javascript = tab2,
  javascriptreact = tab2,
  typescript = tab2,
  typescriptreact = tab2,
  svelte = tab2,
  nix = function(bufnr)
    tab2(bufnr)
    vim.bo[bufnr].commentstring = '# %s'
  end,
  go = function(bufnr)
    vim.bo[bufnr].tabstop = 4
    vim.bo[bufnr].shiftwidth = 4
    vim.bo[bufnr].expandtab = false
  end,
  templ = function(bufnr)
    vim.bo[bufnr].tabstop = 4
    vim.bo[bufnr].shiftwidth = 4
    vim.bo[bufnr].expandtab = false
    vim.bo[bufnr].commentstring = "// %s"
  end
}

vim.api.nvim_create_autocmd({ 'Filetype' }, {
  group = vim.api.nvim_create_augroup('filetype_opts', { clear = true }),
  callback = function(ev)
    local func = filetype_opts[ev.match];
    if func then
      func(ev.buf)
    end
  end
})
