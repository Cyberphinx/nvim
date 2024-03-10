return {
    {
        -- Mason-installs plugins for language servers
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        -- Mason-lspconfig bridges the gap between mason and nvim and provides ensure installed functionality
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "tsserver" },
            })
        end,
    },
    {
        -- Nvim-lspconfig hooks up nvim with language servers to establish communication
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({})
            lspconfig.tsserver.setup({})

            vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover, {})
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
            vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
            vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, {})
            vim.keymap.set({ "n", "v" }, "<space>a", vim.lsp.buf.code_action, {})
        end,
    },
}
