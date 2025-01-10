local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n",     "ErrorMsg" },
            { out,                                "WarningMsg" },
            { "\nand you fucking messed up again" },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
    spec = {

        {
            "MeanderingProgrammer/render-markdown.nvim",
            dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
            ---@module 'render-markdown'
            ---@type render.md.UserConfig
            opts = {},
        },
        {
            "olimorris/codecompanion.nvim",
            dependencies = {
                "nvim-lua/plenary.nvim",
                "nvim-treesitter/nvim-treesitter",
            },
            config = function()
                require("codecompanion").setup({
                    chat = {
                        provider = "ollama",
                        model = "codellama:latest",
                    },
                })
            end,
        },
        { "navarasu/onedark.nvim" },

        {
            "nvim-telescope/telescope.nvim",
            tag = "0.1.8",
            -- or                              , branch = '0.1.x',
            dependencies = { "nvim-lua/plenary.nvim" },
        },

        { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

        {
            "williamboman/mason.nvim",
            config = function()
                require("mason").setup()
            end,
        },
        {
            "williamboman/mason-lspconfig.nvim",
            config = function()
                require("mason-lspconfig").setup({
                    ensure_installed = { "lua_ls", "gopls" },
                })
            end,
        },

        {
            "neovim/nvim-lspconfig",
            config = function()
                local capabilities = require("cmp_nvim_lsp").default_capabilities()
                local lspconfig = require("lspconfig")
                lspconfig.gleam.setup({})
                lspconfig.lua_ls.setup({
                    capabilities = capabilities,
                })
                lspconfig.gopls.setup({
                    capabilities = capabilities,
                })
                lspconfig.cssls.setup({
                    capabilities = capabilities,
                })
                lspconfig.rust_analyzer.setup({
                    capabilities = capabilities,
                })
                lspconfig.jsonls.setup({
                    capabilities = capabilities,
                })
                lspconfig.html.setup({
                    capabilities = capabilities,
                })
                vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
                vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
            end,
        },

        {
            "nvimtools/none-ls.nvim",
            config = function()
                local null_ls = require("null-ls")
                null_ls.setup({
                    sources = {
                        null_ls.builtins.formatting.stylua,
                        null_ls.builtins.formatting.gofumpt,
                        null_ls.builtins.formatting.golines,
                        null_ls.builtins.formatting.goimports,
                        null_ls.builtins.formatting.jq,
                    },
                })

                vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
            end,
        },
        {
            "hrsh7th/cmp-nvim-lsp",
        },
        {
            "L3MON4D3/LuaSnip",
            dependencies = {
                "saadparwaiz1/cmp_luasnip",
                "rafamadriz/friendly-snippets",
            },
        },

        {
            "hrsh7th/nvim-cmp",
            config = function()
                local cmp = require("cmp")
                require("luasnip.loaders.from_vscode").lazy_load()
                cmp.setup({
                    snippet = {
                        -- REQUIRED - you must specify a snippet engine
                        expand = function(args)
                            --vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                            require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
                        end,
                    },
                    window = {
                        --completion = cmp.config.window.bordered(),
                        documentation = cmp.config.window.bordered(),
                    },
                    mapping = cmp.mapping.preset.insert({
                        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                        ["<C-f>"] = cmp.mapping.scroll_docs(4),
                        ["<C-Space>"] = cmp.mapping.complete(),
                        ["<C-e>"] = cmp.mapping.abort(),
                        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    }),
                    sources = cmp.config.sources({
                        { name = "nvim_lsp" },
                        { name = "luasnip" }, -- For luasnip users.
                    }, {
                        { name = "buffer" },
                    }),
                })
            end,
        },
        -- end
        {
            "nvim-tree/nvim-web-devicons",
        },
        -- [[
        -------------------------------------------------
        --| A | B | C                             X | Y | Z |
        ------------------------------------------------- ]]
        {
            "nvim-lualine/lualine.nvim",
            enabled = false, -- Enable to make it look like the screenshot
            dependencies = { "nvim-tree/nvim-web-devicons" },
            config = function()
                require("lualine").setup({
                    options = {
                        icons_enabled = true,
                        theme = "auto",
                        component_separators = { left = "", right = "" },
                        section_separators = { left = "", right = "" },
                        disabled_filetypes = {
                            statusline = {},
                            winbar = {},
                        },
                    },
                })
            end,
        },

        -- best plugin
        {
            "ThePrimeagen/harpoon",
        },
    },

    install = { colorscheme = { "habamax" } },
    checker = { enabled = false },
})
local config = require("nvim-treesitter.configs")
config.setup({
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
})

-- Options / Binds

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader><leader>", builtin.find_files, {})
vim.cmd("au ColorScheme * hi Comment cterm=italic gui=italic")
vim.keymap.set("n", "<leader>e", ':lua require("harpoon.ui").toggle_quick_menu()<CR>')
vim.keymap.set("n", "<a-h>", ':lua require("harpoon.mark").add_file()<CR>')
vim.keymap.set("n", "<C-p>", ":Telescope harpoon marks<CR>")
vim.keymap.set("n", "<leader><Right>", ":lua require('harpoon.ui').nav_next()<CR>")
vim.keymap.set("n", "<leader><Left>", ":lua require('harpoon.ui').nav_prev()<CR>")
vim.keymap.set("n", "<leader>s", ":SupermavenToggle<CR>")
vim.opt.termguicolors = true
vim.opt.swapfile = false
vim.o.undodir = vim.fn.expand("~/.local/share/nvim/undo")
vim.o.undofile = true
vim.cmd("hi Normal ctermbg=none guibg=none")
vim.cmd.colorscheme("onedark")
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)

vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.o.cursorline = false
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set nohlsearch")
vim.opt.clipboard = "unnamedplus"
vim.cmd("set number")
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
vim.api.nvim_set_hl(0, "VertSplit", { bg = "NONE" })
