vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
-- LEADER
vim.g.mapleader = " " -- works across all nvim files
-- Copy Paste
vim.cmd([[
" " Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy
" " Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P
]])

-- Lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
})
end
vim.opt.rtp:prepend(lazypath)

-- Lazy,nvim plugin manager's plugins installation
local plugins = {
    { "rose-pine/neovim", name = "rose-pine" },
    {
      'nvim-telescope/telescope.nvim', tag = '0.1.5',
      dependencies = { 'nvim-lua/plenary.nvim' }
    },
    -- Make telescope faster
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "nvim-tree/nvim-web-devicons",
          "MunifTanjim/nui.nvim",
        }
    }
}
local opts = {}

-- Lazy.nvim's setup function
require("lazy").setup(plugins, opts)

-- Telescope fuzzy finder and live grep
local builtin = require("telescope.builtin")
vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})
vim.keymap.set('n', '<leader>h', builtin.help_tags, {})
require('telescope').setup {
    defaults = {
        file_ignore_patterns = {
            "^./.git/",
            "^./target/",
            "^./build/",
            "^./node_modules/",
            "LICENSE*"
        },
        layout_strategy = 'horizontal',
        layout_config = {
            prompt_position = "top", -- This sets the prompt to the top similar to helix
            height = 0.95,
            width = 0.95,
            horizontal = { -- This makes the display of preview pane on the right-side
                mirror = false,
                preview_width = 0.5,
            }
        },
        mappings = { -- This makes the tab selection work more like helix, top to bottom
            i = {
                ["<Tab>"] = require('telescope.actions').move_selection_next,
                ["<S-Tab>"] = require('telescope.actions').move_selection_previous,
            },
        },
        sorting_strategy = "ascending", -- This reverses the files display order
    },
}
-- Telescope: get fzf loaded and working with extension
require('telescope').load_extension('fzf')

-- Neotree filesystem tree
vim.keymap.set('n', '<leader>n', ':Neotree filesystem reveal left<CR>')

-- Treesitter
local config = require("nvim-treesitter.configs")
config.setup({
    ensure_installed = {"lua", "javascript"},
    highlight = { enable = true },
    indent = { enable = true },
})

-- Themes: Rose Pine
require("rose-pine").setup()
vim.cmd.colorscheme "rose-pine"

