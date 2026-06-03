-- Leader key (must be set before plugins load)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- Silence providers we don't use (suppresses checkhealth noise)
vim.g.loaded_perl_provider   = 0
vim.g.loaded_ruby_provider   = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider   = 0

-- [[ Options ]]
vim.o.number = true
vim.o.mouse = 'a'
vim.o.showmode = false
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true

-- [[ Keymaps ]]
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Diagnostics ]]
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = true,
  virtual_lines = false,
  jump = { float = true },
}

-- [[ Autocommands ]]
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- [[ Plugin manager: lazy.nvim ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system {
    'git', 'clone', '--filter=blob:none', '--branch=stable',
    'https://github.com/folke/lazy.nvim.git', lazypath,
  }
  if vim.v.shell_error ~= 0 then error('Error cloning lazy.nvim:\n' .. out) end
end
vim.opt.rtp:prepend(lazypath)
-- nvim-treesitter installs parsers here; ensure it's on runtimepath
vim.opt.rtp:append(vim.fn.stdpath 'data' .. '/site')

-- [[ Plugins ]]
require('lazy').setup({

  -- Auto-detect indentation
  { 'NMAC427/guess-indent.nvim', opts = {} },

  -- Keybinding hints popup
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font },
      spec = {
        { '<leader>e', group = 'File [E]xplorer' },
        { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>x', group = 'Trouble [X]' },
        { 'gr',        group = 'LSP Actions' },
      },
    },
  },

  -- File browser
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      -- Disable netrw so nvim-tree handles directory opening
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      require('nvim-tree').setup {
        view = { width = 30 },
        renderer = { group_empty = true },
        filters = { dotfiles = false },
      }

      vim.keymap.set('n', '<leader>ee', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file [E]xplorer' })
      vim.keymap.set('n', '<leader>ef', '<cmd>NvimTreeFindFile<CR>', { desc = '[F]ind current file in explorer' })
    end,
  },

  -- Fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function() return vim.fn.executable 'make' == 1 end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        extensions = {
          ['ui-select'] = { require('telescope.themes').get_dropdown() },
        },
      }
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sf',        builtin.find_files,  { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sg',        builtin.live_grep,   { desc = '[S]earch by [G]rep' })
      vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sd',        builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sh',        builtin.help_tags,   { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk',        builtin.keymaps,     { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sc',        builtin.commands,    { desc = '[S]earch [C]ommands' })
      vim.keymap.set('n', '<leader>sr',        builtin.resume,      { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.',        builtin.oldfiles,    { desc = '[S]earch Recent Files' })
      vim.keymap.set('n', '<leader>ss',        builtin.builtin,     { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader><leader>',  builtin.buffers,     { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })

      -- Fuzzy search within current buffer
      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzy search current buffer' })

      -- Grep across open buffers only
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep { grep_open_files = true, prompt_title = 'Grep Open Files' }
      end, { desc = '[S]earch [/] in Open Files' })

      -- LSP pickers (set per-buffer on attach)
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
        callback = function(event)
          local buf = event.buf
          vim.keymap.set('n', 'grr', builtin.lsp_references,              { buffer = buf, desc = '[G]oto [R]eferences' })
          vim.keymap.set('n', 'gri', builtin.lsp_implementations,         { buffer = buf, desc = '[G]oto [I]mplementation' })
          vim.keymap.set('n', 'grd', builtin.lsp_definitions,             { buffer = buf, desc = '[G]oto [D]efinition' })
          vim.keymap.set('n', 'grt', builtin.lsp_type_definitions,        { buffer = buf, desc = '[G]oto [T]ype Definition' })
          vim.keymap.set('n', 'gO',  builtin.lsp_document_symbols,        { buffer = buf, desc = 'Document Symbols' })
          vim.keymap.set('n', 'gW',  builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Workspace Symbols' })
        end,
      })
    end,
  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim',              opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = { notification = { window = { avoid = { 'NvimTree' } } } } },
      'saghen/blink.cmp',
    },
    config = function()
      -- Keymaps and behaviour applied when any LSP attaches to a buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            vim.keymap.set(mode or 'n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end
          map('grn', vim.lsp.buf.rename,       '[R]e[n]ame')
          map('gra', vim.lsp.buf.code_action,  '[G]oto Code [A]ction', { 'n', 'x' })
          map('grD', vim.lsp.buf.declaration,  '[G]oto [D]eclaration')

          -- Highlight symbol references when cursor rests on a word
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method('textDocument/documentHighlight', event.buf) then
            local au = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf, group = au, callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf, group = au, callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
              callback = function(e)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = e.buf }
              end,
            })
          end

          -- Toggle inlay hints if the server supports them
          if client and client:supports_method('textDocument/inlayHint', event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Language servers to install and enable.
      -- Keys are the lspconfig/mason names; values are extra config (empty = defaults).
      -- ty (Astral Python type checker) is configured manually since mason-lspconfig
      -- doesn't map it yet — mason-tool-installer installs it by name just fine.
      local servers = {
        lua_ls = {
          on_init = function(client)
            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              if path ~= vim.fn.stdpath 'config'
                and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
              then return end
            end
            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
              runtime = { version = 'LuaJIT', path = { 'lua/?.lua', 'lua/?/init.lua' } },
              workspace = {
                checkThirdParty = false,
                library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
                  '${3rd}/luv/library',
                  '${3rd}/busted/library',
                }),
              },
            })
          end,
          settings = { Lua = {} },
        },
        ts_ls = {},
        ty    = {},
        stylua = {},
      }

      require('mason-tool-installer').setup {
        ensure_installed = { 'lua_ls', 'stylua', 'ty', 'ruff', 'ts_ls', 'prettier' },
      }

      -- Enable each server using Neovim 0.11's native LSP config API
      for name, config in pairs(servers) do
        vim.lsp.config(name, config)
        vim.lsp.enable(name)
      end
    end,
  },

  -- Formatting on save
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd   = { 'ConformInfo' },
    keys  = {
      {
        '<leader>f',
        function() require('conform').format { async = true, lsp_format = 'fallback' } end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable = { c = true, cpp = true }
        if disable[vim.bo[bufnr].filetype] then return nil end
        return { timeout_ms = 500, lsp_format = 'fallback' }
      end,
      formatters_by_ft = {
        lua              = { 'stylua' },
        python           = { 'ruff_format' },
        javascript       = { 'prettier' },
        typescript       = { 'prettier' },
        javascriptreact  = { 'prettier' },
        typescriptreact  = { 'prettier' },
        json             = { 'prettier' },
        yaml             = { 'prettier' },
        markdown         = { 'prettier' },
      },
    },
  },

  -- Linting
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        python = { 'ruff' },
      }
      vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
        callback = function() lint.try_lint() end,
      })
    end,
  },

  -- Diagnostics panel
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cmd  = 'Trouble',
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<CR>',              desc = 'Workspace Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', desc = 'Buffer Diagnostics (Trouble)' },
      { '<leader>xq', '<cmd>Trouble qflist toggle<CR>',                   desc = 'Quickfix List (Trouble)' },
    },
    opts = {},
  },

  -- Completions
  {
    'saghen/blink.cmp',
    event   = 'VimEnter',
    version = '1.*',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then return end
          return 'make install_jsregexp'
        end)(),
        opts = {},
      },
    },
    opts = {
      keymap     = { preset = 'enter' },
      appearance = { nerd_font_variant = 'mono' },
      completion = { documentation = { auto_show = false, auto_show_delay_ms = 500 } },
      sources    = { default = { 'lsp', 'path', 'snippets' } },
      snippets   = { preset = 'luasnip' },
      fuzzy      = { implementation = 'lua' },
      signature  = { enabled = true },
    },
  },

  -- Colorscheme: Catppuccin Mocha (consistent with tmux)
  {
    'catppuccin/nvim',
    name     = 'catppuccin',
    priority = 1000,
    config   = function()
      require('catppuccin').setup {
        flavour = 'mocha',
        styles  = { comments = {} },  -- no italics in comments
      }
      vim.cmd.colorscheme 'catppuccin'
    end,
  },

  -- Highlight TODO/FIXME/NOTE comments
  {
    'folke/todo-comments.nvim',
    event        = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts         = { signs = false },
  },

  -- Mini: text objects (ai) + statusline
  {
    'nvim-mini/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }

      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      statusline.section_location = function() return '%2l:%-2v' end
    end,
  },

  -- Syntax highlighting and indentation via Tree-sitter
  {
    'nvim-treesitter/nvim-treesitter',
    lazy   = false,
    build  = ':TSUpdate',
    branch = 'main',
    config = function()
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local buf, filetype = args.buf, args.match
          local lang = vim.treesitter.language.get_lang(filetype)
          if not lang then return end
          if not vim.treesitter.language.add(lang) then return end
          vim.treesitter.start(buf, lang)
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘', config = '🛠', event = '📅', ft = '📂', init = '⚙',
      keys = '🗝', plugin = '🔌', runtime = '💻', require = '🌙',
      source = '📄', start = '🚀', task = '📌', lazy = '💤 ',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
