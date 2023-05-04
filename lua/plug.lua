return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- other plugins...

  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'neovim/nvim-lspconfig'
  use 'simrat39/rust-tools.nvim'

  -- Lsp-status for displaying status bar
  -- use 'nvim-lua/lsp-status.nvim'

  -- lualine statusline
  use 'nvim-lualine/lualine.nvim'

  -- Treesitter
  use 'nvim-treesitter/nvim-treesitter'
  use 'HiPhish/nvim-ts-rainbow2'

  -- Debugger
  use 'puremourning/vimspector'

  -- Terminal
  use 'voldikss/vim-floaterm'

  -- Completion framework:
  use 'hrsh7th/nvim-cmp'

  -- LSP completion source:
  use 'hrsh7th/cmp-nvim-lsp'

  -- Useful completion sources:
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-nvim-lsp-signature-help'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/vim-vsnip'

  -- themes
  use 'folke/tokyonight.nvim'
  use({ 'rose-pine/neovim', as = 'rose-pine' })
  use({ "catppuccin/nvim", as = "catppuccin" })


  -- Telescope
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    -- or                            , branch = '0.1.x',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }

  -- Hop
  use {
    'phaazon/hop.nvim',
    branch = 'v2', -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  }

  -- Auto save
  use({
    "Pocco81/auto-save.nvim",
    config = function()
      require("auto-save").setup {
        -- your config goes here
        -- or just leave it empty :)
        enabled = true,
        execution_message = {
          message = function() -- message to print on save
            return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
          end,
          dim = 0.18,               -- dim the color of `message`
          cleaning_interval = 1250, -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
        },
      }
    end,
  })



  -- Icons
  use 'nvim-tree/nvim-web-devicons'

  -- File explorer
  use 'nvim-tree/nvim-tree.lua'

  -- trouble diagnostics
  use 'folke/trouble.nvim'

  -- todo comments
  use {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }

  -- indent blank line
  use "lukas-reineke/indent-blankline.nvim"

  -- nvim autopairs
  use {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
  }

  -- comments
  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }


  -- highlight argument
  use { 'm-demare/hlargs.nvim' }

  -- highlight jump
  use "danilamihailov/beacon.nvim"
end)
