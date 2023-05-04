--[[ init.lua ]]
-- LEADER
-- These keybindings need to be defined before the first /
-- is called; otherwise, it will default to "\"
vim.g.mapleader = " "
-- vim.g.localleader = "\\"

-- disable netrw at the very start of your init.lua (strongly advised) (this is part of nvim-tree setup)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1



-- IMPORTS
require('vars') -- Variables
require('opts') -- Options
require('keys') -- Keymaps
require('plug') -- Plugins

-- nvim-tree setup
require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
      width = 40,
    },
    renderer = {
      group_empty = true,
    },
    filters = {
      dotfiles = false,
    },
    diagnostics = {
      enable = true,
      show_on_dirs = true,
    },
  })

-- Mason Setup
require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

require("mason-lspconfig").setup{
    auomatic_installation = true;
}

-- Theme Setup
-- vim.cmd[[colorscheme tokyonight-moon]]
vim.cmd('colorscheme rose-pine')
-- vim.cmd('colorscheme rose-pine-moon')
-- vim.cmd('colorscheme rose-pine-dawn')
-- vim.cmd.colorscheme "catppuccin-macchiato"


-- Rust Tools Setup
local rt = require("rust-tools")

rt.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
})



-- LSP config
local lspconfig = require('lspconfig')
--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.html.setup ({
    capabilities = capabilities,
})
lspconfig.cssls.setup({
    capabilities = capabilities,
})

lspconfig.tsserver.setup ({
    capabilities = capabilities,
})

lspconfig.svelte.setup ({
    capabilities = capabilities,
})

-- lspconfig.eslint.setup({
--   --- ...
--   on_attach = function(client, bufnr)
--     vim.api.nvim_create_autocmd("BufWritePre", {
--       buffer = bufnr,
--       command = "EslintFixAll",
--     })
--   end,
-- })

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})




-- LSP Diagnostics Options Setup
local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end

sign({ name = 'DiagnosticSignError', text = '●' })
sign({ name = 'DiagnosticSignWarn', text = '■' })
sign({ name = 'DiagnosticSignHint', text = '▎' })
sign({ name = 'DiagnosticSignInfo', text = 'x' })

vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  update_in_insert = true,
  underline = true,
  severity_sort = false,
  float = {
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
})

vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])


-- Completion Plugin Setup
local cmp = require 'cmp'
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    })
  },
  -- Installed sources:
  sources = {
    { name = 'path' },                         -- file paths
    { name = 'nvim_lsp',               keyword_length = 3 }, -- from language server
    { name = 'nvim_lsp_signature_help' },      -- display function signatures with current parameter emphasized
    { name = 'nvim_lua',               keyword_length = 2 }, -- complete neovim's Lua runtime API such vim.lsp.*
    { name = 'buffer',                 keyword_length = 2 }, -- source current buffer
    { name = 'vsnip',                  keyword_length = 2 }, -- nvim-cmp source for vim-vsnip
    { name = 'calc' },                         -- source for math calculation
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  formatting = {
    fields = { 'menu', 'abbr', 'kind' },
    format = function(entry, item)
      local menu_icon = {
        nvim_lsp = 'λ',
        vsnip = '⋗',
        buffer = 'Ω',
        path = '🖫',
      }
      item.menu = menu_icon[entry.source.name]
      return item
    end,
  },
})


-- Treesitter Plugin Setup
--
local rainbow = require 'ts-rainbow'
--
require('nvim-treesitter.configs').setup {
  ensure_installed = { "lua", "rust", "toml", "svelte", "typescript", "javascript", "html", "css", "tsx", "yaml", "json" },
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  autotag = { enable = true },
  indent = { enable = true },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
    query = {
      'rainbow-parens'
    },
    strategy = rainbow.strategy.global,
    hlgroups = {
      'TSRainbowRed',
      'TSRainbowYellow',
      'TSRainbowBlue',
      'TSRainbowOrange',
      'TSRainbowGreen',
      'TSRainbowViolet',
      'TSRainbowCyan'
    },
  },
}

-- Telescope Setup
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>sf', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- Trouble Setup
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>",
  { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",
  { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",
  { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>",
  { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",
  { silent = true, noremap = true }
)
vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>",
  { silent = true, noremap = true }
)
-- jump to the next item, skipping the groups
require("trouble").next({ skip_groups = true, jump = true });
-- jump to the previous item, skipping the groups
require("trouble").previous({ skip_groups = true, jump = true });
-- jump to the first item, skipping the groups
require("trouble").first({ skip_groups = true, jump = true });
-- jump to the last item, skipping the groups
require("trouble").last({ skip_groups = true, jump = true });

local actions = require("telescope.actions")
local trouble = require("trouble.providers.telescope")

local telescope = require("telescope")

telescope.setup {
  defaults = {
    mappings = {
      i = { ["<c-t>"] = trouble.open_with_trouble },
      n = { ["<c-t>"] = trouble.open_with_trouble },
    },
  },
}

-- Hop Setup
-- place this in one of your configuration file(s)
local hop = require('hop')
local directions = require('hop.hint').HintDirection
vim.keymap.set('', 'f', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
end, { remap = true })
vim.keymap.set('', 'F', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
end, { remap = true })
vim.keymap.set('', '<leader>t', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
end, { remap = true })
vim.keymap.set('', '<leader>T', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
end, { remap = true })


-- autopairs
require('nvim-autopairs').setup()

-- Comment
require('Comment').setup()

-- indent blank line
vim.opt.list = true
-- vim.opt.listchars:append "space:⋅"
-- vim.opt.listchars:append "eol:↴"
require("indent_blankline").setup {
  space_char_blankline = " ",
  show_current_context = true,
  show_current_context_start = true,
}

-- Nvim Web Devicons
require 'nvim-web-devicons'.setup {
  -- your personnal icons can go here (to override)
  -- you can specify color or cterm_color instead of specifying both of them
  -- DevIcon will be appended to `name`
  override = {
    zsh = {
      icon = "",
      color = "#428850",
      cterm_color = "65",
      name = "Zsh"
    }
  },
  -- globally enable different highlight colors per icon (default to true)
  -- if set to false all icons will have the default icon's color
  color_icons = true,
  -- globally enable default icons (default to false)
  -- will get overriden by `get_icons` option
  default = true,
  -- globally enable "strict" selection of icons - icon will be looked up in
  -- different tables, first by filename, and if not found by extension; this
  -- prevents cases when file doesn't have any extension but still gets some icon
  -- because its name happened to match some extension (default to false)
  strict = true,
  -- same as `override` but specifically for overrides by filename
  -- takes effect when `strict` is true
  override_by_filename = {
    [".gitignore"] = {
      icon = "",
      color = "#f1502f",
      name = "Gitignore"
    }
  },
  -- same as `override` but specifically for overrides by extension
  -- takes effect when `strict` is true
  override_by_extension = {
    ["log"] = {
      icon = "",
      color = "#81e043",
      name = "Log"
    }
  },
}

-- highlight arguments
require('hlargs').setup()



-- lualine statusline
require('lualine').setup()
