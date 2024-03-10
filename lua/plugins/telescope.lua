return {
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function ()
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
                            preview_width = 0.618,
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
        end
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
              require("telescope").setup({
              extensions = {
                ["ui-select"] = {
                  require("telescope.themes").get_dropdown {
                  }
                }
              }
            })
            require("telescope").load_extension("ui-select")
        end
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim", build = "make"
    }
}
