return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim"
  },
  config = function ()
    local harpoon = require('harpoon');

---@diagnostic disable-next-line: missing-parameter
    harpoon:setup()

    vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
    vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end)
    vim.keymap.set("n", "<leader>d", function() harpoon:list():remove() end)
    --
    -- IM DUMB (below mapping would have been as easier as above line)
    -- vim.keymap.set("n", "<leader>d", function()
    --   -- dumps item related to current buffer from default list
    --   local actual_list = harpoon:list()
    --   local bufname = vim.api.nvim_buf_get_name(0)
    --   local item = actual_list:get_by_display(bufname)
    --   actual_list:remove(item)
    -- end)
    --

    -- removed cause this bindings are too awful and dont really need
    -- the bindings
    -- vim.keymap.set("n", "<C-1>", function() harpoon:list():select(1) end)
    -- vim.keymap.set("n", "<C-2>", function() harpoon:list():select(2) end)
    -- vim.keymap.set("n", "<C-3>", function() harpoon:list():select(3) end)
    -- vim.keymap.set("n", "<C-4>", function() harpoon:list():select(4) end)

    -- Toggle previous & next buffers stored within Harpoon list
    -- vim.keymap.set("n", "<leader>a",function() harpoon:list():prev() end)
    vim.keymap.set("n", "<C-M-P>", function() harpoon:list():prev() end)
    vim.keymap.set("n", "<C-M-N>", function() harpoon:list():next() end)

  end
}
