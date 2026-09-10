-- nvim-treesitter `main` branch: the old module system (`nvim-treesitter.configs`
-- with highlight/indent/incremental_selection/textobjects tables) is gone.
-- Highlighting and folds now come from Neovim itself, indentation from this
-- plugin's `indentexpr`, and textobjects from explicit keymaps.

local ensure_installed = {
  'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx',
  'javascript', 'typescript', 'vimdoc', 'vim', 'bash',
}

-- Selects `node` charwise, mirroring what the old incremental_selection did.
local function select_node(node)
  local sr, sc, er, ec = node:range()
  if ec == 0 then -- node ends at column 0: pull back onto the previous line
    er = er - 1
    ec = #(vim.api.nvim_buf_get_lines(0, er, er + 1, false)[1] or '')
  end
  vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
  vim.cmd('normal! v')
  vim.api.nvim_win_set_cursor(0, { er + 1, math.max(ec - 1, 0) })
end

local function same_range(a, b)
  local a1, a2, a3, a4 = a:range()
  local b1, b2, b3, b4 = b:range()
  return a1 == b1 and a2 == b2 and a3 == b3 and a4 == b4
end

-- Incremental selection was dropped upstream, so keep a small node stack here.
local stack = {}

local function init_selection()
  local node = vim.treesitter.get_node()
  if not node then return end
  stack = { node }
  select_node(node)
end

local function node_incremental()
  local node = stack[#stack] or vim.treesitter.get_node()
  if not node then return end
  local parent = node:parent()
  while parent and same_range(parent, node) do -- skip ancestors that add nothing
    parent = parent:parent()
  end
  if not parent then return end
  table.insert(stack, parent)
  select_node(parent)
end

local function node_decremental()
  if #stack < 2 then return end
  table.remove(stack)
  select_node(stack[#stack])
end

local function scope_incremental()
  local node = stack[#stack] or vim.treesitter.get_node()
  if not node then return end

  local ok, parser = pcall(vim.treesitter.get_parser)
  if not ok or not parser then return node_incremental() end

  local got, query = pcall(vim.treesitter.query.get, parser:lang(), 'locals')
  if not got or not query then return node_incremental() end

  local scopes = {}
  for id, n in query:iter_captures(parser:parse()[1]:root(), 0) do
    if query.captures[id] == 'local.scope' then
      scopes[n:id()] = true
    end
  end

  local parent = node:parent()
  while parent do
    if scopes[parent:id()] then
      table.insert(stack, parent)
      return select_node(parent)
    end
    parent = parent:parent()
  end
  node_incremental()
end

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
    },
    config = function()
      local ts = require('nvim-treesitter')
      ts.setup()

      -- `ensure_installed` is no longer a setup option; install what's missing.
      local installed = ts.get_installed()
      local missing = vim.tbl_filter(function(lang)
        return not vim.tbl_contains(installed, lang)
      end, ensure_installed)
      if #missing > 0 then
        ts.install(missing)
      end

      -- highlight = { enable = true } / indent = { enable = true }
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('user_treesitter', { clear = true }),
        callback = function(args)
          if pcall(vim.treesitter.start, args.buf) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      require('nvim-treesitter-textobjects').setup {
        select = {
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        },
        move = {
          set_jumps = true, -- whether to set jumps in the jumplist
        },
      }

      local select = require('nvim-treesitter-textobjects.select')
      local move = require('nvim-treesitter-textobjects.move')
      local swap = require('nvim-treesitter-textobjects.swap')

      -- select
      --  You can use the capture groups defined in textobjects.scm
      local selections = {
        ['aa'] = { '@parameter.outer', 'textobjects' },
        ['ia'] = { '@parameter.inner', 'textobjects' },
        ['af'] = { '@function.outer', 'textobjects' },
        ['if'] = { '@function.inner', 'textobjects' },
        ['ac'] = { '@class.outer', 'textobjects' },
        ['ic'] = { '@class.inner', 'textobjects' },
        ['as'] = { '@scope', 'locals', 'Select around language scope' },
        ['is'] = { '@scope', 'locals', 'Select inside language scope' },
      }
      for keys, spec in pairs(selections) do
        vim.keymap.set({ 'x', 'o' }, keys, function()
          select.select_textobject(spec[1], spec[2])
        end, { desc = spec[3] })
      end

      -- move
      local movements = {
        goto_next_start = { [']p'] = '@parameter.inner', [']m'] = '@function.outer', [']]'] = '@class.outer' },
        goto_next_end = { [']M'] = '@function.outer', [']['] = '@class.outer' },
        goto_previous_start = { ['[p'] = '@parameter.inner', ['[m'] = '@function.outer', ['[['] = '@class.outer' },
        goto_previous_end = { ['[M'] = '@function.outer', ['[]'] = '@class.outer' },
      }
      for fn, keymaps in pairs(movements) do
        for keys, query in pairs(keymaps) do
          vim.keymap.set({ 'n', 'x', 'o' }, keys, function()
            move[fn](query, 'textobjects')
          end)
        end
      end

      -- swap
      vim.keymap.set('n', '<leader>sp', function()
        swap.swap_next('@parameter.inner')
      end)
      vim.keymap.set('n', '<leader>SP', function()
        swap.swap_previous('@parameter.inner')
      end)

      -- incremental_selection
      vim.keymap.set('n', '<c-space>', init_selection)
      vim.keymap.set('x', '<c-space>', node_incremental)
      vim.keymap.set('x', '<c-s>', scope_incremental)
      vim.keymap.set('x', '<M-space>', node_decremental)
    end,
  },
}
