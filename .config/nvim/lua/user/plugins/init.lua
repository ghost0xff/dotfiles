return {
    -- automatically adjusts 'shiftwidth' and 'expandtab'
    -- dont like this plugin but keeping here just in case
    'tpope/vim-sleuth',
    --  ^^^
    "eandrju/cellular-automaton.nvim",
    'ryanoasis/vim-devicons',
    {
        "folke/zen-mode.nvim",
        opts = {},
        config = function()
            vim.keymap.set("n", "<leader>z", ":ZenMode<CR>")
        end
    },
    {
        'numToStr/Comment.nvim',
        opts = {},
        lazy = false
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        main = 'ibl',
        opts = {},
    },
    {
        "prettier/vim-prettier",
    },
    {
        "mbbill/undotree",
        config = function()
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        end
    },
    {
        'rose-pine/neovim',
        name = 'rose-pine',
        priority = 1000,
        variant = "main",
        config = function()
            require('rose-pine').setup({
                styles = {
                    transparency = true,
                }
            })
            vim.cmd("colorscheme rose-pine")
        end
    },

    -- {
    --     "folke/tokyonight.nvim",
    --     lazy = false,
    --     priority = 1000,
    --     opts = {},
    --     config = function()
    --         require("tokyonight").setup({
    --             transparent = true
    --         })
    --
    --         vim.cmd("colorscheme tokyonight-night")
    --         -- vim.api.nvim_set_hl(0, "Nrmal", { bg = "none" })
    --         -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    --     end
    -- },


    -- {
    --     "bluz71/vim-moonfly-colors",
    --     name = "moonfly",
    --     lazy = false,
    --     priority = 1000,
    --     config = function()
    --         vim.cmd("colorscheme moonfly")
    --         vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    --     end
    -- },

    -- {
    --     "bratpeki/truedark-vim",
    --     lazy = false,
    --     priority = 1000,
    --     opts = {},
    --     config = function()
    --         vim.cmd("colorscheme truedark")
    --     end
    -- },

    -- {
    --     "catppuccin/nvim",
    --     name = "catppuccin",
    --     priority = 1000,
    --     config = function()
    --         vim.cmd("colorscheme catppuccin-macchiato")
    --     end
    -- },
    {
        "utilyre/barbecue.nvim",
        name = "barbecue",
        version = "*",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons", -- optional dependency
        },
        opts = {
        },
    },

    {
        'nvim-lualine/lualine.nvim',
        opts = {
            options = {
                icons_enable = true,
                theme = 'rose-pine',
                component_separators = '|',
                section_separators = '',
            },
        },
    },
}
