return {
    {
        -- Mason installs plugins for language servers
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    {
        -- Mason lspconfig provides ensure installed functionality
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "tsserver" }
            })
        end
    },
    {
        -- nvim lspconfig hooks up nvim with language servers to establish communication
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({})
            lspconfig.tsserver.setup({})

            vim.keymap.set('n', '<leader>k', vim.lsp.buf.hover, {})
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
            vim.keymap.set({ 'n', 'v' }, '<space>a', vim.lsp.buf.code_action, {})
        end
    }
}
