-- options that saved my life
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.o.cursorline = true
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set nohlsearch")
vim.opt.clipboard = "unnamedplus"

-- vim.cmd("set mouse=") i hate you firefox
vim.cmd("set number") -- uncomment if you like this
-- Bootstrap lazy.nvim
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

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
    spec = {

        -- super maven
        --		{
        --			"ramojus/mellifluous.nvim",
        --			version = "v1.*", -- uncomment for stable config (some features might be missed if/when v1 comes out)
        --			config = function()
        --				require("mellifluous").setup({}) -- optional, see configuration section.
        --			end,
        --		},
        {
            "zenbones-theme/zenbones.nvim",
            dependencies = "rktjmp/lush.nvim",
            lazy = false,
            priority = 1000,
            -- you can set set configuration options here
            -- config = function()
            --     vim.g.zenbones_darken_comments = 45
            --     vim.cmd.colorscheme('zenbones')
            -- end
        },
        {
            "MeanderingProgrammer/render-markdown.nvim",
            dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
            -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
            -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
            ---@module 'render-markdown'
            ---@type render.md.UserConfig
            opts = {},
        },
        --		{
        --			"romgrk/barbar.nvim",
        --			init = function()
        --				vim.g.barbar_auto_setup = false
        --			end,
        --			opts = {},
        --		},

        {
            "supermaven-inc/supermaven-nvim",
            config = function()
                require("supermaven-nvim").setup({})
            end,
        },

        --		{
        --			"sainnhe/gruvbox-material",
        --			lazy = false,
        --			priority = 1000,
        --			config = function()
        --				-- Optionally configure and load the colorscheme
        --				-- directly inside the plugin declaration.
        --				vim.g.gruvbox_material_enable_italic = true
        --				vim.g.gruvbox_material_background = "soft"
        --				vim.cmd.colorscheme("gruvbox-material")
        --			end,
        --		},

        -- init.lua:
        {
            "nvim-telescope/telescope.nvim",
            tag = "0.1.8",
            -- or                              , branch = '0.1.x',
            dependencies = { "nvim-lua/plenary.nvim" },
        },

        { "norcalli/nvim-colorizer.lua" },
        --		{
        --			"neanias/everforest-nvim",
        --			version = false,
        --			lazy = false,
        --			priority = 1000,
        --			config = function()
        --				require("everforest").setup({
        --					background = "hard",
        --				})
        --			end,
        --		},

        {
            "nvim-lualine/lualine.nvim",
            enabled = true,
            dependencies = { "nvim-tree/nvim-web-devicons" },
            config = function()
                require("lualine").setup({
                    icons_enabled = true,
                    theme = "auto",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    disabled_filetypes = {
                        statusline = {},
                        winbar = {},
                    },
                })
            end,
        },
        -- lazy.nvim
        --		{
        --			"folke/noice.nvim",
        --			enabled = true,
        --			event = "VeryLazy",
        --			opts = {
        --				-- add any options here
        --				views = {
        --					cmdline_popup = {
        --						border = {
        --							style = "none",
        --							padding = { 2, 3 },
        --						},
        --						filter_options = {},
        --						win_options = {
        --							winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
        --						},
        --					},
        --				},
        --			},
        --			dependencies = {
        --				-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        --				-- OPTIONAL:
        --				--   `nvim-notify` is only needed, if you want to use the notification view.
        --				--   If not available, we use `mini` as the fallback
        --			},
        --		},

        -- Lua
        {
            "folke/zen-mode.nvim",
            opts = {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            },
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
        --		{
        --			"nvim-lualine/lualine.nvim",
        --			config = function()
        --				require("lualine").setup({
        --					sections = {
        --						lualine_a = { "mode" },
        --						lualine_b = { "branch", "diff", "diagnostics" },
        --						lualine_c = { "filename" },
        --						lualine_x = { "encoding" },
        --						lualine_y = { "progress" },
        --						lualine_z = { "location" },
        --					},
        --				})
        --			end,
        --		},

        -- best plugin
        {
            "ThePrimeagen/harpoon",
        },
        --		{
        --			"ggandor/leap.nvim",
        --			init = function()
        --				require("leap").add_default_mappings()
        --			end,
        --			dependencies = {
        --				"tpope/vim-repeat",
        --			},
        --			lazy = false,
        --		},
    },

    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "habamax" } },
    -- automatically check for plugin updates
    checker = { enabled = false },
})
local config = require("nvim-treesitter.configs")
config.setup({
    --ensure_installed = { "lua", "go", "nix" },
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
})
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader><leader>", builtin.find_files, {})
vim.cmd("au ColorScheme * hi Comment cterm=italic gui=italic")
-- binds
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
-- vim.cmd("colorscheme mellifluous")
vim.cmd.colorscheme("zenbones")
--vim.cmd("set background=light")
require("colorizer").setup()
