return {
  'nvim-neotest/neotest',
  dependencies = {
    'fredrikaverpil/neotest-golang',
    -- Your other test adapters here
  },
  keys = {
    {
      '<leader>tt',
      function()
        require('neotest').run.run()
      end,
      desc = '[T]est: runs the nearest [T]est',
    },
    {
      '<leader>tdt',
      function()
        require('neotest').run.run { strategy = 'dap' }
      end,
      desc = '[T]est: [D]ebug the nearest [T]ests',
    },
    {
      '<leader>tf',
      function()
        require('neotest').run.run(vim.fn.expand '%')
      end,
      desc = '[T]est: runs the current [F]ile',
    },
    {
      '<leader>ts',
      function()
        require('neotest').run.run(vim.fn.expand '%')
      end,
      desc = '[T]est: [S]top',
    },
  },
  config = function()
    -- get neotest namespace (api call creates or returns namespace)
    local neotest_ns = vim.api.nvim_create_namespace 'neotest'
    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          local message = diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
          return message
        end,
      },
    }, neotest_ns)
    require('neotest').setup {
      -- your neotest config here
      adapters = {
        require 'neotest-golang' {
          env = {
            KAFKA_ADDRESS = 'localhost:9092',
            SQS_ADDRESS = 'http://127.0.0.1:4566',
            S3_ADDRESS = 'http://127.0.0.1:4566',
            DYNAMO_ADDRESS = 'http://127.0.0.1:4566',
            ENV = 'local',
          },
        },
      },
    }
  end,
}
