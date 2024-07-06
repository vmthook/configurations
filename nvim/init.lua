-- one-file minimalistic config july 2024
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/nvim-cmp',
		}
	},
	{
		'windwp/nvim-autopairs',
		event = 'InsertEnter',
		config = true
	},
	{
		'nvim-telescope/telescope.nvim',
		dependencies = {'nvim-lua/plenary.nvim'}
	},
	{
		'nvim-lualine/lualine.nvim',
		dependencies = {'nvim-tree/nvim-web-devicons'}
	}
})

vim.g.mapleader = ' '

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.cmdheight = 0
vim.opt.scrolloff = 8
vim.opt.cursorline = true
vim.opt.number = true

vim.g.netrw_liststyle = 3
vim.g.clipboard = 'unnamedplus'

vim.cmd('colorscheme evening')

local ts = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', ts.find_files, {})
vim.keymap.set('n', '<leader>g', ts.live_grep, {})
vim.keymap.set('n', '<leader>j', ':bnext<CR>')
vim.keymap.set('n', '<leader>k', ':bprev<CR>')
vim.keymap.set('n', '<leader>d', ':bd<CR>')

local cmp = require('cmp')
cmp.setup({
	snippet = {
		expand = function(args)
			vim.snippet.expand(args.body)
		end
	},
	window = {},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
	}, {
		{ name = 'buffer' },
	})
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

require('lspconfig')['lua_ls'].setup({
	capabilities = capabilities
})

require('lspconfig')['clangd'].setup({
	capabilities = capabilities
})


require('lualine').setup({
  options = {
    icons_enabled = false,
    theme = 'wombat',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {''},
    lualine_c = {{
			'buffers',
			symbols = {
				modified = '*',
				alternate_file = ''
			}
		}},
		lualine_x = {'branch', 'diff', 'diagnostics'},
    lualine_y = {''},
    lualine_z = {''}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {
		-- actual good tabline
	},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
})
