vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = ""
vim.opt.showmode = false
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.hlsearch = true
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {
	desc = "Go to previous [D]iagnostic message",
})
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {
	desc = "Go to next [D]iagnostic message",
})
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {
	desc = "Show diagnostic [E]rror messages",
})
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, {
	desc = "Open diagnostic [Q]uickfix list",
})
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", {
	desc = "Exit terminal mode",
})
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", {
	desc = "Move focus to the left window",
})
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", {
	desc = "Move focus to the right window",
})
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", {
	desc = "Move focus to the lower window",
})
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", {
	desc = "Move focus to the upper window",
})

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", {
		clear = true,
	}),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- use typescript-tools with conform to format on save
local autocmd = vim.api.nvim_create_autocmd
local Format = vim.api.nvim_create_augroup("Format", { clear = true })
autocmd("BufWritePre", {
	group = Format,
	pattern = "*.ts,*.tsx,*.jsx,*.js",
	callback = function(args)
		vim.cmd("TSToolsOrganizeImports sync") -- sync keyword avoids race cond.
		vim.cmd("TSToolsAddMissingImports sync")
		require("conform").format({ bufnr = args.buf })
	end,
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)
vim.opt.termguicolors = true

local plugins = {
	"tpope/vim-sleuth",
	{
		"junegunn/goyo.vim",
		dependencies = {
			"preservim/vim-pencil",
			"arnamak/stay-centered.nvim",
		},
		cmd = "Goyo",
		keys = {
			{ "<leader>z", "<cmd>Goyo<CR>", desc = "[Z]en mode" },
		},
		config = function()
			-- Define Lua functions for entering and leaving Goyo mode
			local function goyo_enter()
				require("lualine").hide()
				vim.cmd("Pencil")
				vim.cmd("PencilSoft")
				require("stay-centered").toggle()
			end

			local function goyo_leave()
				require("lualine").hide({ unhide = true })
				vim.cmd("PencilOff")
				require("stay-centered").toggle()
			end

			-- Create an augroup for Goyo mode
			local augroup_id = vim.api.nvim_create_augroup("Goyo", { clear = true })

			-- Define autocommands for GoyoEnter and GoyoLeave
			vim.api.nvim_create_autocmd("User", {
				pattern = "GoyoEnter",
				callback = goyo_enter,
				group = augroup_id,
			})

			vim.api.nvim_create_autocmd("User", {
				pattern = "GoyoLeave",
				callback = goyo_leave,
				group = augroup_id,
			})
		end,
	},
	{
		"preservim/vim-pencil",
		dependencies = { "godlygeek/tabular" },
	},
	{
		"voldikss/vim-floaterm",
		keys = {
			{ "<leader>tn", "<cmd>FloatermNew<CR>", desc = "[T]erminal [n]ew" },
			{ "<leader>tt", "<cmd>FloatermToggle<CR>", desc = "[T]erminal [t]oggle" },
			{ "<leader>tk", "<cmd>FloatermKill<CR>", desc = "[T]erminal [k]ill" },
			{ "<leader>tl", "<cmd>FloatermNext<CR>", desc = "[T]erminal next" },
			{ "<leader>th", "<cmd>FloatermPrev<CR>", desc = "[T]erminal previous" },
		},
	},
	{
		"numToStr/Comment.nvim",
		opts = {},
	},
	{
		"folke/which-key.nvim",
		event = "VimEnter",
		config = function()
			local wk = require("which-key")
			wk.setup()
			wk.add({
				{ "<leader>t", group = "[T]erminal", icon = { icon = "", color = "yellow" } },
				{ "<leader>g", group = "[G]it" },
				{ "<leader>l", group = "[L]SP" },
				{ "<leader>f", group = "[F]ormat", icon = { icon = "", color = "green" } },
				{ "<leader>c", group = "[C]omment", icon = { icon = "󰆈", color = "blue" } },
				{ "<leader>d", group = "[D]ocument", icon = { icon = "", color = "orange" } },
				{ "<leader>r", group = "[R]ename" },
				{ "<leader>s", group = "[S]earch", icon = { icon = "", color = "red" } },
				{ "<leader>w", group = "[W]orkspace", icon = { icon = "󰇃", color = "green" } },
			})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{
				"nvim-tree/nvim-web-devicons",
				enabled = vim.g.have_nerd_font,
			},
		},
		config = function()
			require("telescope").setup({
				defaults = { file_ignore_patterns = { "node_modules" } },
				extensions = {
					["ui-select"] = { require("telescope.themes").get_dropdown() },
				},
			})
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, {
				desc = "[S]earch [H]elp",
			})
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, {
				desc = "[S]earch [K]eymaps",
			})
			vim.keymap.set("n", "<leader>sf", builtin.find_files, {
				desc = "[S]earch [F]iles",
			})
			vim.keymap.set("n", "<leader>ss", builtin.builtin, {
				desc = "[S]earch [S]elect Telescope",
			})
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, {
				desc = "[S]earch current [W]ord",
			})
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, {
				desc = "[S]earch by [G]rep",
			})
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, {
				desc = "[S]earch [D]iagnostics",
			})
			vim.keymap.set("n", "<leader>sr", builtin.resume, {
				desc = "[S]earch [R]esume",
			})
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, {
				desc = '[S]earch Recent Files ("." for repeat)',
			})
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, {
				desc = "[ ] Find existing buffers",
			})
			vim.keymap.set("n", "<leader>/", function()
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, {
				desc = "[/] Fuzzily search in current buffer",
			})
			vim.keymap.set("n", "<leader>s/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, {
				desc = "[S]earch [/] in Open Files",
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{
				"j-hui/fidget.nvim",
				opts = {},
			},
			{
				"folke/neodev.nvim",
				opts = {},
			},
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", {
					clear = true,
				}),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, {
							buffer = event.buf,
							desc = "LSP: " .. desc,
						})
					end

					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
					map(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.documentHighlightProvider then
						local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", {
							clear = false,
						})
						vim.api.nvim_create_autocmd({ "cursorhold", "cursorholdi" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", {
								clear = true,
							}),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({
									group = "kickstart-lsp-highlight",
									buffer = event2.buf,
								})
							end,
						})
					end

					-- if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
					-- 	map("<leader>th", function()
					-- 		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
					-- 	end, "[T]oggle Inlay [H]ints")
					-- end
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			local servers = {
				-- biome = {},
				-- gopls = {},
				tailwindcss = {},
				emmet_language_server = {},
				eslint = {
					on_attach = function(_, bufnr)
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = bufnr,
							command = "EslintFixAll",
						})
					end,
				},
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
			}

			require("mason").setup()

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
	{ -- Obsidian.nvim
		"epwalsh/obsidian.nvim",
		version = "*",
		lazy = true,
		ft = "markdown",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"hrsh7th/nvim-cmp",
			"nvim-treesitter/nvim-treesitter",
			"epwalsh/pomo.nvim",
		},
		opts = { workspaces = { { name = "work", path = "~/vaults/work" } } },
	},
	{ "epwalsh/pomo.nvim" },
	{ -- Autoformat
		"stevearc/conform.nvim",
		lazy = false,
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({
						async = true,
						lsp_fallback = true,
					})
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function()
				return {
					timeout_ms = 2500,
					lsp_fallback = true,
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				nix = { "nixfmt" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				markdown = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
			},
		},
	},
	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = { -- Snippet Engine & its associated nvim-cmp source
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					-- Build Step is needed for regex support in snippets.
					-- This step is not supported in many windows environments.
					-- Remove the below condition to re-enable on windows.
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					-- `friendly-snippets` contains a variety of premade snippets.
					--    See the README about individual language/framework/plugin snippets:
					--    https://github.com/rafamadriz/friendly-snippets
					-- {
					--   'rafamadriz/friendly-snippets',
					--   config = function()
					--     require('luasnip.loaders.from_vscode').lazy_load()
					--   end,
					-- },
				},
			},
			"saadparwaiz1/cmp_luasnip", -- Adds other completion capabilities.
			--  nvim-cmp does not ship with all sources by default. They are split
			--  into multiple repos for maintenance purposes.
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
		},
		config = function()
			-- See `:help cmp`
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup({})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = {
					completeopt = "menu,menuone,noinsert",
				},

				-- For an understanding of why these mappings were
				-- chosen, you will need to read `:help ins-completion`
				--
				-- No, but seriously. Please read `:help ins-completion`, it is really good!
				mapping = cmp.mapping.preset.insert({
					-- Select the [n]ext item
					["<C-n>"] = cmp.mapping.select_next_item(),
					-- Select the [p]revious item
					["<C-p>"] = cmp.mapping.select_prev_item(),

					-- Scroll the documentation window [b]ack / [f]orward
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),

					-- Accept ([y]es) the completion.
					--  This will auto-import if your LSP supports it.
					--  This will expand snippets if the LSP sent a snippet.
					["<C-y>"] = cmp.mapping.confirm({
						select = true,
					}),

					-- If you prefer more traditional completion keymaps,
					-- you can uncomment the following lines
					-- ['<CR>'] = cmp.mapping.confirm { select = true },
					-- ['<Tab>'] = cmp.mapping.select_next_item(),
					-- ['<S-Tab>'] = cmp.mapping.select_prev_item(),

					-- Manually trigger a completion from nvim-cmp.
					--  Generally you don't need this, because nvim-cmp will display
					--  completions whenever it has completion options available.
					["<C-Space>"] = cmp.mapping.complete({}),

					-- Think of <c-l> as moving to the right of your snippet expansion.
					--  So if you have a snippet that's like:
					--  function $name($args)
					--    $body
					--  end
					--
					-- <c-l> will move you to the right of each of the expansion locations.
					-- <c-h> is similar, except moving you backwards.
					["<C-l>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),
					["<C-h>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),

					-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
					--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
				}),
				sources = {
					{
						name = "nvim_lsp",
					},
					{
						name = "luasnip",
					},
					{
						name = "path",
					},
				},
			})
		end,
	},
	{ -- You can easily change to a different colorscheme.
		-- Change the name of the colorscheme plugin below, and then
		-- change the command in the config to whatever the name of that colorscheme is.
		--
		-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
		"sainnhe/everforest",
		priority = 1000, -- Make sure to load this before all the other start plugins.
		init = function()
			-- Load the colorscheme here.
			-- Like many other themes, this one has different styles, and you could load
			-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
			-- vim.cmd.colorscheme("murphy")
			vim.cmd.colorscheme("murphy")

			-- You can configure highlights by doing something like:
			vim.cmd.hi("Comment gui=none")
		end,
	}, -- Highlight todo, notes, etc in comments
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			signs = false,
		},
	},
	{ "tpope/vim-surround" },
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			theme = "16color",
		},
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{ -- Collection of various small independent plugins/modules
		"echasnovski/mini.nvim",
		config = function()
			-- Better Around/Inside textobjects
			--
			-- Examples:
			--  - va)  - [V]isually select [A]round [)]paren
			--  - yinq - [Y]ank [I]nside [N]ext [']quote
			--  - ci'  - [C]hange [I]nside [']quote
			require("mini.ai").setup({
				n_lines = 500,
			})

			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			--
			-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - sd'   - [S]urround [D]elete [']quotes
			-- - sr)'  - [S]urround [R]eplace [)] [']
			-- disabled to use tpope/vim-surround instead
			-- require("mini.surround").setup()
		end,
	},
	{
		"davidmh/mdx.nvim",
		config = true,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
	},
	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			ensure_installed = { "bash", "c", "diff", "html", "lua", "luadoc", "markdown", "vim", "vimdoc" },
			auto_install = true,
			highlight = {
				enable = true,
				-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
				--  If you are experiencing weird indenting issues, add the language to
				--  the list of additional_vim_regex_highlighting and disabled languages for indent.
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = {
				enable = true,
				disable = { "ruby" },
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.install").prefer_git = true
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	-- BEGIN DASHBOARD
	{

		"goolord/alpha-nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			local logo = [[
                                ...----....
                         ..-:"''         ''"-..
                      .-'                      '-.
                    .'              .     .       '.
                  .'   .          .    .      .    .''.
                .'  .    .       .   .   .     .   . ..:.
              .' .   . .  .       .   .   ..  .   . ....::.
             ..   .   .      .  .    .     .  ..  . ....:IA.
            .:  .   .    .    .  .  .    .. .  .. .. ....:IA.
           .: .   .   ..   .    .     . . .. . ... ....:.:VHA.
           '..  .  .. .   .       .  . .. . .. . .....:.::IHHB.
          .:. .  . .  . .   .  .  . . . ...:.:... .......:HIHMM.
         .:.... .   . ."::"'.. .   .  . .:.:.:II;,. .. ..:IHIMMA
         ':.:..  ..::IHHHHHI::. . .  ...:.::::.,,,. . ....VIMMHM
        .:::I. .AHHHHHHHHHHAI::. .:...,:IIHHHHHHMMMHHL:. . VMMMM
       .:.:V.:IVHHHHHHHMHMHHH::..:" .:HIHHHHHHHHHHHHHMHHA. .VMMM.
       :..V.:IVHHHHHMMHHHHHHHB... . .:VPHHMHHHMMHHHHHHHHHAI.:VMMI
       ::V..:VIHHHHHHMMMHHHHHH. .   .I":IIMHHMMHHHHHHHHHHHAPI:WMM
       ::". .:.HHHHHHHHMMHHHHHI.  . .:..I:MHMMHHHHHHHHHMHV:':H:WM
       :: . :.::IIHHHHHHMMHHHHV  .ABA.:.:IMHMHMMMHMHHHHV:'. .IHWW
       '.  ..:..:.:IHHHHHMMHV" .AVMHMA.:.'VHMMMMHHHHHV:' .  :IHWV
        :.  .:...:".:.:TPP"   .AVMMHMMA.:. "VMMHHHP.:... .. :IVAI
       .:.   '... .:"'   .   ..HMMMHMMMA::. ."VHHI:::....  .:IHW'
       ...  .  . ..:IIPPIH: ..HMMMI.MMMV:I:.  .:ILLH:.. ...:I:IM
     : .   .'"' .:.V". .. .  :HMMM:IMMMI::I. ..:HHIIPPHI::'.P:HM.
     :.  .  .  .. ..:.. .    :AMMM IMMMM..:...:IV":T::I::.".:IHIMA
     'V:.. .. . .. .  .  .   'VMMV..VMMV :....:V:.:..:....::IHHHMH
       "IHH:.II:.. .:. .  . . . " :HB"" . . ..PI:.::.:::..:IHHMMV"
      ]]

			dashboard.section.header.val = vim.split(logo, "\n")

			-- Split logo into lines
			local logoLines = {}
			for line in logo:gmatch("[^\r\n]+") do
				table.insert(logoLines, line)
			end

			local builtin = require("telescope.builtin")
			dashboard.section.buttons.val = {
				dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
				dashboard.button("r", " Search Recent Files", builtin.oldfiles),
				dashboard.button("q", "󰅚  Quit", ":qa<CR>"),
				{ type = "padding", val = 2 },
			}

			-- Set footer
			local footer = [[
     
      [...] begin every action with the following question:
      "Who am I, that I choose to prefer my own will and desires to the will of God and His command?"
      In addition, strictly follow the commandment of Christ to never judge anyone.
      - St. Pitirm
    ]]

			dashboard.section.footer.val = footer
			dashboard.section.footer.type = "text"
			dashboard.section.footer.opts = {
				position = "center",
				hl = "Number",
			}

			-- Keymaps
			vim.keymap.set("n", "<leader>a", ":Alpha<CR>", { desc = "Goto Greeter Screen" })
			alpha.setup(dashboard.opts)
		end,
	},
	{
		"github/copilot.vim",
	},
	{
		-- run :TransparentEnable once to transparent bg.
		-- this value will be cached for subsequent loads
		"xiyaowong/transparent.nvim",
		event = "VimEnter",
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		cmd = "Neotree",
		keys = {
			{ "\\", ":Neotree reveal<CR>", { desc = "NeoTree reveal" } },
		},
		opts = {
			filesystem = {
				filtered_items = {
					visible = true,
					show_hidden_count = true,
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_by_name = {
						"node_modules",
						".git",
						".DS_Store",
						"thumbs.db",
					},
					never_show = {},
				},
				window = {
					mappings = {
						["\\"] = "close_window",
					},
				},
			},
		},
	},
	{
		"wallpants/github-preview.nvim",
		cmd = { "GithubPreviewToggle" },
		keys = { "<leader>mpt" },
		opts = {
			-- config goes here
		},
		config = function(_, opts)
			local gpreview = require("github-preview")
			gpreview.setup(opts)

			local fns = gpreview.fns
			vim.keymap.set("n", "<leader>mpt", fns.toggle)
			vim.keymap.set("n", "<leader>mps", fns.single_file_toggle)
			vim.keymap.set("n", "<leader>mpd", fns.details_tags_toggle)
		end,
	},
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = { settings = {
			jsx_close_tag = {
				enable = true,
			},
		} },
	},
	{ "m4xshen/autoclose.nvim" },
	{
		"APZelos/blamer.nvim",
		keys = {
			{
				"<leader>b",
				":BlamerToggle<CR>",
				desc = "Git [B]lame",
			},
		},
	},
}
local home = os.getenv("HOME")
local workconfig_path = home .. "/.config/nvim/workconfig.lua"

-- Check if the workconfig.lua file exists
local file_exists = function(path)
	local f = io.open(path, "r")
	if f then
		f:close()
		return true
	end
	return false
end

if file_exists(workconfig_path) then
	WorkConfig = dofile(workconfig_path)
	if WorkConfig and WorkConfig.codeium_server_config then
		WorkConfig.codeium_server_config()
	end
	if WorkConfig and WorkConfig.plugin_config then
		for _, plugin in ipairs(WorkConfig.plugin_config) do
			table.insert(plugins, plugin)
		end
	end
end

require("lazy").setup(plugins, {
	ui = {
		-- If you are using a Nerd Font: set icons to an empty table which will use the
		-- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
