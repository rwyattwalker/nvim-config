-------------------------------------------------
-- PLUGINS
-------------------------------------------------
-- Bootstrap Packer
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- Dashboard is a nice start screen for nvim
   use 'glepnir/dashboard-nvim'

    -- Telescope and related plugins --
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use { "nvim-telescope/telescope-file-browser.nvim",
        config = function()
        require("telescope").setup {
          extensions = {
            file_browser = {
              theme = "ivy",
              -- disables netrw and use telescope-file-browser in its place
              hijack_netrw = true,
              mappings = {
                ["i"] = {
                  -- your custom insert mode mappings
                },
                ["n"] = {
                  -- your custom normal mode mappings
                },
              },
            },
          },
        }
        end
  }
  -- To get telescope-file-browser loaded and working with telescope,
  -- you need to call load_extension, somewhere after setup function:
  require("telescope").load_extension "file_browser"
  -- Buffer
  use 'kyazdani42/nvim-web-devicons'
  use {'akinsho/bufferline.nvim', tag = "v2.*", requires = 'kyazdani42/nvim-web-devicons'}
  vim.opt.termguicolors = true
    require("bufferline").setup{options = {
    offsets = {
      { filetype = "NvimTree", text = "", padding = 1 },
      { filetype = "neo-tree", text = "", padding = 1 },
      { filetype = "Outline", text = "", padding = 1 },
    },
    max_name_length = 14,
    max_prefix_length = 13,
    tab_size = 20,
    separator_style = "thick",
    },
  }
  --Buffer Delete
  use 'famiu/bufdelete.nvim'
  -- Treesitter --
  use {'nvim-treesitter/nvim-treesitter',
       config = function()
          require'nvim-treesitter.configs'.setup {
          -- If TS highlights are not enabled at all, or disabled via `disable` prop,
          -- highlighting will fallback to default Vim syntax highlighting
            highlight = {
               enable = true,
               additional_vim_regex_highlighting = {'org'}, -- Required for spellcheck, some LaTex highlights and code block highlights that do not have ts grammar
               },
            ensure_installed = {'org'}, -- Or run :TSUpdate org
            }
       end
  }

  -- Productivity --
  use 'vimwiki/vimwiki'
  use {'nvim-orgmode/orgmode',
       config = function()
          require('orgmode').setup{
             org_agenda_files = {'~/nc/Org/agenda.org'},
             org_default_notes_file = '~/nc/Org/notes.org',
                                  }
       end
  }
  require('orgmode').setup_ts_grammar()

  -- Which key
  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      }
    end
  }

  -- A better status line --
  use { 'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  require('lualine').setup()

  -- File management --
  use 'vifm/vifm.vim'
  use 'ryanoasis/vim-devicons'
  vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

  use {
  "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = { 
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    }
  }

  -- Tim Pope Plugins --
  use 'tpope/vim-surround'

  -- Syntax Highlighting and Colors --
  use 'PotatoesMaster/i3-vim-syntax'
  use 'kovetskiy/sxhkd-vim'
  use 'vim-python/python-syntax'
  use 'ap/vim-css-color'

  -- Junegunn Choi Plugins --
  use 'junegunn/goyo.vim'
  use 'junegunn/limelight.vim'

  -- Colorschemes --
  use "EdenEast/nightfox.nvim"
  use 'RRethy/nvim-base16'
  use "ellisonleao/gruvbox.nvim"
  use 'kyazdani42/nvim-palenight.lua'
  -- LSP
 use {
   'neovim/nvim-lspconfig',
    config = function () require("configs.lspconfig") end,
  }
use "williamboman/nvim-lsp-installer"
 require("nvim-lsp-installer").setup({
    automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
    ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗"
        }
    }
})
  --Git Integration
   use {
  'lewis6991/gitsigns.nvim',
  }
  require('gitsigns').setup()
  --Auto Complete
  use {
    'saadparwaiz1/cmp_luasnip', 'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline', 'hrsh7th/cmp-nvim-lua'
  }
  use {
    'hrsh7th/nvim-cmp',
    config = function () require("configs.cmp") end,
    requires = {
      {'L3MON4D3/LuaSnip'},        --used in config
      {'onsails/lspkind.nvim'},    --used in config
    },
    --after = 'LuaSnip',
  }
  --snippet luasnip
  use {
    'L3MON4D3/LuaSnip',
    --after = 'nvim-cmp',
    config = function () require("configs.luasnip") end,
    requires = {'rafamadriz/friendly-snippets'},
  }
  --terminal
  use {"akinsho/toggleterm.nvim", tag = '*', config = function()
  require("toggleterm").setup()
    end}
  -- Other stuff --
  use 'frazrepo/vim-rainbow'

if packer_bootstrap then
    require('packer').sync()
  end
end)
