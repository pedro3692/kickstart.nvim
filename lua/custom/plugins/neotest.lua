local env = {
  KAFKA_ADDRESS = 'localhost:9092',
  SQS_ADDRESS = 'http://127.0.0.1:4566',
  S3_ADDRESS = 'http://127.0.0.1:4566',
  DYNAMO_ADDRESS = 'http://127.0.0.1:4566',
  POSTGRES_ADDRESS = '127.0.0.1:5432',
  VALKEY_ADDRESS = '127.0.0.1:6379',
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
  -- overmind
  VLAD_SECRETS = '{"secrets":{"databasepassword":{"value":"overmind"},"apikey":{"value":"degredo"}}}',
}

local adapter_config = {
  runner = 'gotestsum',
  sanitize_output = true,
  go_test_args = {
    '-v',
    '-race',
    '-count=1',
    '-coverprofile=' .. vim.fn.getcwd() .. '/coverage.out',
  },
  warn_test_name_dupes = false,
  env = vim.tbl_extend('force', vim.fn.environ(), env),
  filter_dirs = {
    '.git',
    'node_modules',
    '.venv',
    'venv',
    'vendor',
  },
}

return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    {
      'fredrikaverpil/neotest-golang',
      dependencies = {
        'uga-rosa/utf8.nvim', -- sanitize output
      },
    },
  },
  opts = {
    -- See all config options with :h neotest.Config
    discovery = {
      -- Drastically improve performance in ginormous projects by
      -- only AST-parsing the currently opened buffer.
      enabled = false,
      -- Number of workers to parse files concurrently.
      -- A value of 0 automatically assigns number based on CPU.
      -- Set to 1 if experiencing lag.
      concurrent = 0,
    },
    running = {
      -- Run tests concurrently when an adapter provides multiple commands to run.
      concurrent = true,
    },
    summary = {
      -- Enable/disable animation of icons.
      animated = true,
    },
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
        vim.env.GOFLAGS = '-tags=debug'
        require('neotest').run.run {
          strategy = 'dap',
          adapters = {
            require 'neotest-golang'(adapter_config),
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
        require 'neotest-golang'(adapter_config),
      },
    }
  end,
}
