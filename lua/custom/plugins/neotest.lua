local env = {
  KAFKA_ADDRESS = 'localhost:9092',
  SQS_ADDRESS = 'http://127.0.0.1:4566',
  S3_ADDRESS = 'http://127.0.0.1:4566',
  DYNAMO_ADDRESS = 'http://127.0.0.1:4566',
  POSTGRES_ADDRESS = '127.0.0.1:5432',
  REDIS_NODE_1 = '127.0.0.1:7000',
  REDIS_NODE_2 = '127.0.0.1:7001',
  REDIS_NODE_3 = '127.0.0.1:7002',
  ENV = 'local',
  -- spectra stuff
  REDIS = '127.0.0.1:6379',
  KAFKA_BROKERS = 'localhost:9092',
  AWS_REGION = 'eu-west-3',
  DB_USERNAME = 'spectra',
  DB_PASSWORD = 'spectra',
  DB_DATABASE = 'spectradb',
}

return {
  'nvim-neotest/neotest',
  dependencies = {
    {
      'fredrikaverpil/neotest-golang',
      version = '*', -- Optional, but recommended; track releases
      build = function()
        vim.system({ 'go', 'install', 'gotest.tools/gotestsum@latest' }):wait() -- Optional, but recommended
      end,
    },
    -- Your other test adapters here
  },
  keys = {
    {
      '<leader>tt',
      function()
        require('neotest').run.run {
          adapters = {
            require 'neotest-golang' {
              env = vim.tbl_extend('force', vim.fn.environ(), env),
            },
          },
        }
      end,
      desc = '[T]est: runs the nearest [T]est',
    },
    {
      '<leader>tdt',
      function()
        require('neotest').run.run {
          strategy = 'dap',
          adapters = {
            require 'neotest-golang' {
              env = vim.tbl_extend('force', vim.fn.environ(), env),
            },
          },
        }
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
    {
      '<leader>to',
      function()
        require('neotest').output_panel.toggle()
      end,
      desc = '[T]est: [O]utput panel',
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
          env = vim.tbl_extend('force', vim.fn.environ(), env),
        },
      },
    }
  end,
}
