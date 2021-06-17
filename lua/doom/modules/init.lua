----- Plugins modules
-- Essentials         / (Plugin manager, vimpeccable, treesitter, sessions)
-- UI Related         / (All look-and-feel plugins)
-- Fuzzy Search       ! (Fuzzy searching)
-- Git Integration    + (Some git plugins like LazyGit)
-- Completion         + (Built-in LSP configurations)
-- File-related       + (EditorConfig, formatting, Tree-sitter, etc)
-- Web-related        + (Colorizer, emmet, rest client)
--
-- Legend:
--   ! : The group and its plugins cannot be disabled
--   / : The group cannot be disabled but some of its plugins can be
--   + : The group and its plugins can be disabled
--
-- NOTES:
--   1. You can disable an entire group or just some or their plugins based on
--        the legend, please refer to our documentation to learn how to do it.
--   2. We do not provide other LSP integration like coc.nvim,
--        please refer to our FAQ to see why.

--- Disabled modules
local disabled_git = has_value(Doom.disabled_modules, 'git')
local disabled_lsp = has_value(Doom.disabled_modules, 'lsp')
local disabled_files = has_value(Doom.disabled_modules, 'files')
local disabled_web = has_value(Doom.disabled_modules, 'web')

vim.cmd([[ packadd packer.nvim ]])

local packer = require('packer')

-- Change some defaults
packer.init({
	git = {
		clone_timeout = 300, -- 5 mins
	},
	profile = {
		enable = true,
	},
})

packer.startup(function(use)
	-----[[------------]]-----
	---     Essentials     ---
	-----]]------------[[-----
	-- Plugins manager, remove the branch field when that branch is merged
	-- in the main branch.
	use({
		'wbthomason/packer.nvim',
		opt = true,
	})

	-- Tree-Sitter
	local disabled_treesitter =
		has_value(Doom.disabled_plugins, 'treesitter')
	use({
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		config = require('doom.modules.doom-treesitter'),
		disable = (disabled_files and true or disabled_treesitter),
		event = 'BufEnter',
	})

	-- Sessions
	use({
		'rmagatti/auto-session',
		config = require('doom.modules.doom-autosession'),
		requires = { { 'rmagatti/session-lens', after = 'telescope.nvim' } },
		cmd = { 'SaveSession', 'RestoreSession', 'DeleteSession' },
		event = 'TabNewEntered',
	})

	-----[[------------]]-----
	---     UI Related     ---
	-----]]------------[[-----
	-- Fancy start screen
	-- cannot be disabled
	use({
		'glepnir/dashboard-nvim',
		config = require('doom.modules.doom-dashboard'),
		cmd = 'Dashboard',
	})

	-- Doom Colorschemes
	local disabled_doom_themes =
		has_value(Doom.disabled_plugins, 'doom-themes')
	use({
		'GustavoPrietoP/doom-themes.nvim',
		disable = disabled_doom_themes,
		event = 'TabNewEntered',
	})

	-- File tree
	local disabled_tree = has_value(Doom.disabled_plugins, 'tree')
	use({
		'kyazdani42/nvim-tree.lua',
		requires = { 'kyazdani42/nvim-web-devicons' },
		config = require('doom.modules.doom-tree'),
		disable = disabled_tree,
		cmd = {
			'NvimTreeClipboard',
			'NvimTreeClose',
			'NvimTreeFindFile',
			'NvimTreeOpen',
			'NvimTreeRefresh',
			'NvimTreeToggle',
		},
	})

	-- Statusline
	-- can be disabled to use your own statusline
	local disabled_statusline =
		has_value(Doom.disabled_plugins, 'statusline')
	use({
		'glepnir/galaxyline.nvim',
		config = require('doom.modules.doom-eviline'),
		disable = disabled_statusline,
		event = 'ColorScheme',
	})

	-- Tabline
	-- can be disabled to use your own tabline
	local disabled_tabline = has_value(Doom.disabled_plugins, 'tabline')
	use({
		'akinsho/nvim-bufferline.lua',
		config = require('doom.modules.doom-bufferline'),
		disable = disabled_tabline,
		event = 'ColorScheme',
	})

	-- Better terminal
	-- can be disabled to use your own terminal plugin
	local disabled_terminal = has_value(Doom.disabled_plugins, 'terminal')
	use({
		'akinsho/nvim-toggleterm.lua',
		config = require('doom.modules.doom-toggleterm'),
		disable = disabled_terminal,
		module = 'toggleterm.terminal',
		cmd = { 'ToggleTerm', 'TermExec' },
		keys = { 'n', '<F4>' },
	})

	-- Viewer & finder for LSP symbols and tags
	local disabled_outline = has_value(Doom.disabled_plugins, 'outline')
	use({
		'simrat39/symbols-outline.nvim',
		config = require('doom.modules.doom-symbols'),
		disable = disabled_outline,
		cmd = {
			'SymbolsOutline',
			'SymbolsOutlineOpen',
			'SymbolsOutlineClose',
		},
	})

	-- Minimap
	-- Depends on wfxr/code-minimap to work!
	local disabled_minimap = has_value(Doom.disabled_plugins, 'minimap')
	use({
		'wfxr/minimap.vim',
		disable = disabled_minimap,
		cmd = {
			'Minimap',
			'MinimapClose',
			'MinimapToggle',
			'MinimapRefresh',
			'MinimapUpdateHighlight',
		},
	})

	-- Keybindings menu like Emacs's guide-key
	-- cannot be disabled
	use({
		'folke/which-key.nvim',
		config = require('doom.modules.doom-whichkey'),
        event = 'BufEnter',
	})

	-- Distraction free environment
	local disabled_zen = has_value(Doom.disabled_plugins, 'zen')
	use({
		'kdav5758/TrueZen.nvim',
		config = require('doom.modules.doom-zen'),
		disable = disabled_zen,
		module = 'true-zen',
		event = 'TabNewEntered',
	})

	-----[[--------------]]-----
	---     Fuzzy Search     ---
	-----]]--------------[[-----
	use({
		'nvim-telescope/telescope.nvim',
		cmd = 'Telescope',
		requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } },
		config = require('doom.modules.doom-telescope'),
	})

	-----[[-------------]]-----
	---     GIT RELATED     ---
	-----]]-------------[[-----
	-- Git gutter better alternative, written in Lua
	-- can be disabled to use your own git gutter plugin
	local disabled_gitsigns = has_value(Doom.disabled_plugins, 'gitsigns')
	use({
		'lewis6991/gitsigns.nvim',
		config = require('doom.modules.doom-gitsigns'),
		disable = (disabled_git and true or disabled_gitsigns),
		event = 'ColorScheme',
	})

	-- LazyGit integration
	local disabled_lazygit = has_value(Doom.disabled_plugins, 'lazygit')
	use({
		'kdheepak/lazygit.nvim',
		requires = { 'nvim-lua/plenary.nvim' },
		disable = (disabled_git and true or disabled_lazygit),
		cmd = { 'LazyGit', 'LazyGitConfig' },
	})

	-----[[------------]]-----
	---     Completion     ---
	-----]]------------[[-----
	-- Built-in LSP Config
	-- NOTE: It should not be disabled if you are going to use LSP!
	local disabled_lspconfig = has_value(Doom.disabled_plugins, 'lspconfig')
	use({
		'neovim/nvim-lspconfig',
		config = require('doom.modules.doom-lspconfig'),
		disable = (disabled_lsp and true or disabled_lspconfig),
		event = 'ColorScheme',
	})

	-- Completion plugin
	-- can be disabled to use your own completion plugin
	local disabled_compe = has_value(Doom.disabled_plugins, 'compe')
	use({
		'hrsh7th/nvim-compe',
		requires = {
			{
				'ray-x/lsp_signature.nvim',
				config = require('doom.modules.doom-lsp-signature'),
			},
			{
				'onsails/lspkind-nvim',
				config = require('doom.modules.doom-lspkind'),
			},
			{ 'norcalli/snippets.nvim' },
		},

		config = require('doom.modules.doom-compe'),
		disable = (disabled_lsp and true or disabled_compe),
		opt = true,
		after = 'nvim-lspconfig',
	})

	-- install lsp saga
	local disabled_lspsaga = has_value(Doom.disabled_plugins, 'lspsaga')
	use({
		'glepnir/lspsaga.nvim',
		disable = (disabled_lsp and true or disabled_lspsaga),
		opt = true,
		after = 'nvim-lspconfig',
	})

	-- provides the missing `:LspInstall` for `nvim-lspconfig`.
	local disabled_lspinstall =
		has_value(Doom.disabled_plugins, 'lspinstall')
	use({
		'kabouzeid/nvim-lspinstall',
		config = require('doom.modules.doom-lspinstall'),
		disable = (disabled_lsp and true or disabled_lspinstall),
		after = 'nvim-lspconfig',
	})

	-----[[--------------]]-----
	---     File Related     ---
	-----]]--------------[[-----
	-- Write / Read files without permissions (e.vim.g. /etc files) without having
	-- to use `sudo nvim /path/to/file`
	local disabled_suda = has_value(Doom.disabled_plugins, 'suda')
	use({
		'lambdalisue/suda.vim',
		disable = (disabled_files and true or disabled_suda),
		cmd = { 'SudaRead', 'SudaWrite' },
	})

	-- File formatting
	-- can be disabled to use your own file formatter
	local disabled_formatter = has_value(Doom.disabled_plugins, 'formatter')
	use({
		'lukas-reineke/format.nvim',
		config = require('doom.modules.doom-format'),
		disable = (disabled_files and true or disabled_formatter),
		event = 'BufEnter',
	})

	-- Autopairs
	-- can be disabled to use your own autopairs
	local disabled_autopairs = has_value(Doom.disabled_plugins, 'autopairs')
	use({
		'windwp/nvim-autopairs',
		config = require('doom.modules.doom-autopairs'),
		disable = (disabled_files and true or disabled_autopairs),
		event = 'InsertEnter',
	})

	-- Indent Lines
	local disabled_indent_lines =
		has_value(Doom.disabled_plugins, 'indentlines')
	use({
		'lukas-reineke/indent-blankline.nvim',
		branch = 'lua',
		config = require('doom.modules.doom-blankline'),
		disable = (disabled_files and true or disabled_indent_lines),
		event = 'ColorScheme',
	})

	-- EditorConfig support
	local disabled_editorconfig =
		has_value(Doom.disabled_plugins, 'editorconfig')
	use({
		'editorconfig/editorconfig-vim',
		disable = (disabled_files and true or disabled_editorconfig),
		event = 'TabNewEntered',
	})

	-- Comments
	-- can be disabled to use your own comments plugin
	local disabled_kommentary =
		has_value(Doom.disabled_plugins, 'kommentary')
	use({
		'b3nj5m1n/kommentary',
		disable = (disabled_files and true or disabled_kommentary),
		after = 'nvim-lspconfig',
	})

	-----[[-------------]]-----
	---     Web Related     ---
	-----]]-------------[[-----
	-- Fastest colorizer without external dependencies!
	local disabled_colorizer = has_value(Doom.disabled_plugins, 'colorizer')
	use({
		'norcalli/nvim-colorizer.lua',
		config = require('doom.modules.doom-colorizer'),
		disable = (disabled_web and true or disabled_colorizer),
		event = 'ColorScheme',
	})

	-- HTTP Client support
	-- Depends on bayne/dot-http to work!
	local disabled_restclient =
		has_value(Doom.disabled_plugins, 'restclient')
	use({
		'bayne/vim-dot-http',
		disable = (disabled_web and true or disabled_restclient),
		cmd = 'DotHttp',
	})

	-- Emmet plugin
	local disabled_emmet = has_value(Doom.disabled_plugins, 'emmet')
	use({
		'mattn/emmet-vim',
		disable = (disabled_web and true or disabled_emmet),
		event = 'ColorScheme',
	})

	-----[[----------------]]-----
	---     Custom Plugins     ---
	-----]]----------------[[-----
	-- If there are custom plugins then also require them
	for _, plug in pairs(Doom.custom_plugins) do
		custom_plugins(plug)
	end
end)