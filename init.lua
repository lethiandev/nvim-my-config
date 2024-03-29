-- Plugins
local Plug = vim.fn['plug#']

vim.call('plug#begin')
Plug('neovim/nvim-lspconfig')
Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('folke/tokyonight.nvim')
Plug('nvim-tree/nvim-web-devicons')
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate'})
Plug('windwp/nvim-ts-autotag')
Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim', { tag = '0.1.5' })
Plug('nvim-telescope/telescope-fzy-native.nvim')
Plug('nvim-telescope/telescope-file-browser.nvim')
Plug('natecraddock/workspaces.nvim')
Plug('folke/trouble.nvim')
Plug('lewis6991/gitsigns.nvim')
Plug('sbdchd/neoformat')
Plug('akinsho/toggleterm.nvim', { tag = '*' })
Plug('nvim-lualine/lualine.nvim')
Plug('NeogitOrg/neogit')
Plug('nvimdev/lspsaga.nvim')
Plug('lukas-reineke/indent-blankline.nvim')
vim.call('plug#end')

-- Editor Settings
vim.opt.encoding = "UTF-8"
vim.opt.scrolloff = 8
vim.opt.number = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.listchars = "trail:·,tab:» "
vim.opt.list = true
vim.opt.colorcolumn = "80"

vim.opt.termguicolors = true
vim.cmd.colorscheme('tokyonight')

vim.opt.spelllang = "en_gb"
vim.opt.spell = true

-- Enable LSP servers
local lspconfig = require'lspconfig'
local capabilities = require'cmp_nvim_lsp'.default_capabilities()

function _G.lsp_organize_imports()
  vim.lsp.buf.execute_command({
    command = '_typescript.organizeImports',
    arguments = {vim.api.nvim_buf_get_name(0)},
    title = "TS Organize Imports",
  })
end

function _G.lsp_code_action()
  vim.lsp.buf.code_action()
end

lspconfig.tsserver.setup {
  capabilities = capabilities,
  commands = {
    OrganizeImports = {
      _G.lsp_organize_imports,
      description = 'TS Organize Imports',
    },
    CodeAction = {
      _G.lsp_code_action,
      description = 'TS Code Action',
    },
  },
}

lspconfig.tailwindcss.setup {}

lspconfig.lua_ls.setup {
  settings = {
    Lua = {
      diagnostics = {
        globals = {'vim'},
      },
    },
  },
}

-- nvim-cmp Setup
require'cmp'.setup {
  sources = {
    { name = 'nvim_lsp' },
  },
}

-- Web Icons Setup
require'nvim-web-devicons'.setup {}

-- Treesitter Setup
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  autotag = {
    enable = true,
  },
  ensure_installed = {
    "json",
    "javascript",
    "typescript",
    "tsx",
    "yaml",
    "html",
    "css",
    "lua",
    "bash",
    "gitignore",
    "markdown",
    "markdown_inline",
  },
}

-- Telescope Setup
require'telescope'.setup {}
require'telescope'.load_extension 'fzy_native'
require'telescope'.load_extension 'file_browser'
require'telescope'.load_extension 'workspaces'

-- Workspaces Setup
require'workspaces'.setup {}

-- Gitsigns Setup
require'gitsigns'.setup {}

-- Toggleterm Setup
require'toggleterm'.setup {
  open_mapping = [[<C-\>]],
  --shell = [[C:/PROGRA~1/Git/bin/bash.exe --login -i]],
}

function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
  vim.keymap.set('t', '<C-c>', [[:TermExec cmd=<C-c><CR>]], opts)
  vim.opt_local.scrolloff = 0
  vim.opt_local.spell = false
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

-- Lualine Setup
require'lualine'.setup {}

-- Neogit Setup
require'neogit'.setup {}

-- Neoformat Setup
vim.cmd([[
augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END
]])

-- Lspsaga Setup
require'lspsaga'.setup {
  code_action = {
    num_shortcut = true,
    show_server_name = true,
    extend_gitsigns = true,
  },
  lightbulb = {
    enable = false,
  },
  diagnostic = {
    show_layout = 'normal',
    jump_num_shortcut = true,
  },
}

-- Map key strokes
local builtin = require'telescope.builtin'
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fb', ':Telescope file_browser<CR>', { noremap = true })
vim.keymap.set('n', '<leader>fc', ':Telescope file_browser path=%:p:h select_buffer=true<CR>', { noremap = true })

vim.keymap.set('n', ']t', '<cmd>tabnext<CR>', {})
vim.keymap.set('n', '[t', '<cmd>tabprevious<CR>', {})
vim.keymap.set('n', '<leader>tn', '<cmd>tabnew<CR>', {})
vim.keymap.set('n', '<leader>td', '<cmd>bd<CR>', {})

vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<CR>', {})
vim.keymap.set('n', ']e', '<cmd>Lspsaga diagnostic_jump_next<CR>', {})
vim.keymap.set('n', '[e', '<cmd>Lspsaga diagnostic_jump_prev<CR>', {})
vim.keymap.set('n', '<leader>dd', '<cmd>lua vim.diagnostic.open_float()<CR>', {})

-- Indent Blankline Setup
require'ibl'.setup {}
