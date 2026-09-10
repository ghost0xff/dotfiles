return {
    {
        "windwp/nvim-ts-autotag",
        dependencies = {
            'nvim-treesitter/nvim-treesitter'
        },
        config = function()
            require("nvim-ts-autotag").setup()
        end
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        opts = {
        } -- this is equalent to setup({}) function
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'rafamadriz/friendly-snippets',
        },
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'williamboman/mason.nvim', config = true },
            'williamboman/mason-lspconfig.nvim',
            { 'j-hui/fidget.nvim',       opts = {} },
            'folke/neodev.nvim',
        },
        config = function()
            local on_attach = function(_, bufnr)
                local nmap = function(keys, func, desc)
                    if desc then
                        desc = 'LSP: ' .. desc
                    end
                    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
                end


                nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
                nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
                nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

                nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
                nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
                nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
                nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
                nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
                nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

                -- Lesser used LSP functionality
                nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
                nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
                nmap('<leader>wl', function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, '[W]orkspace [L]ist Folders')

                -- Create a command `:Format` local to the LSP buffer
                vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
                    -- local server_name = vim.lsp.get_active_clients()[1].name
                    -- if (server_name == 'pyright') then
                    --     vim.cmd("silent !black %")
                    --     return
                    -- end
                    vim.lsp.buf.format({
                        formatting_options = {
                            -- tabSize = 4
                            tabSize = vim.o.shiftwidth
                        }
                    })
                    -- vim.print(vim.o.shiftwidth)
                end, { desc = 'Format current buffer with LSP' })
                nmap('<leader>f', ":Format<CR>", '[F]ormat document')

            end

            -- To instead override globally
            -- NOTE: hoisted out of on_attach so the wrapper is applied once,
            -- rather than re-wrapped on every LSP attach.

            -- local border = {
            --   { "🭽", "FloatBorder" },
            --   { "▔", "FloatBorder" },
            --   { "🭾", "FloatBorder" },
            --   { "▕", "FloatBorder" },
            --   { "🭿", "FloatBorder" },
            --   { "▁", "FloatBorder" },
            --   { "🭼", "FloatBorder" },
            --   { "▏", "FloatBorder" },
            -- }
            local border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
            local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
            ---@diagnostic disable-next-line: duplicate-set-field
            function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
                opts = opts or {}
                opts.border = opts.border or border
                return orig_util_open_floating_preview(contents, syntax, opts, ...)
            end

            -- on_attach is no longer passed per-server; LspAttach drives it.
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                    on_attach(vim.lsp.get_client_by_id(args.data.client_id), args.buf)
                end,
            })


            require('mason').setup()

            local servers = {
                -- clangd = {},
                -- gopls = {},
                -- pyright = {},
                -- rust_analyzer = {},
                -- tsserver = {},
                -- html = { filetypes = { 'html', 'twig', 'hbs'} },

                lua_ls = {
                    Lua = {
                        workspace = { checkThirdParty = false },
                        telemetry = { enable = false },
                        -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                        -- diagnostics = { disable = { 'missing-fields' } },
                    },
                },
            }
            -- Setup neovim lua configuration
            require('neodev').setup()

            -- broadcast additional nvim-cmp completion capabilities to servers
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

            -- mason-lspconfig v2 removed setup_handlers. Servers are configured
            -- through vim.lsp.config and switched on by `automatic_enable`.
            vim.lsp.config('*', { capabilities = capabilities })

            for server_name, settings in pairs(servers) do
                vim.lsp.config(server_name, {
                    capabilities = capabilities,
                    settings = settings,
                    filetypes = (settings or {}).filetypes,
                })
            end

            -- Ensure the servers above are installed, then enable them
            require('mason-lspconfig').setup {
                ensure_installed = vim.tbl_keys(servers),
                automatic_enable = true,
            }
        end
    },
}
