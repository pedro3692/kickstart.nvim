return {
  {
    'MagicDuck/grug-far.nvim',
    cmd = 'GrugFar',
    keys = {
      {
        '<leader>S',
        function()
          require('grug-far').toggle_instance { instanceName = 'far', staticTitle = 'Find and Replace' }
        end,
        desc = 'Toggle GrugFar',
      },
      {
        '<leader>sw',
        function()
          require('grug-far').open { prefills = { search = vim.fn.expand '<cword>' } }
        end,
        desc = 'Search current word',
      },
      {
        '<leader>sw',
        function()
          require('grug-far').with_visual_selection()
        end,
        mode = 'v',
        desc = 'Search selection',
      },
    },
    opts = {},
  },
}
