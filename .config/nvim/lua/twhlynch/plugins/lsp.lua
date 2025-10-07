return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"jcha0713/cmp-tw2css",
		"hrsh7th/nvim-cmp",
	},

	config = function()
		-- stylua: ignore

		require("mason").setup()
		require("mason-lspconfig").setup({
			automatic_installation = false,
			ensure_installed = {
				"lua_ls",
				"basedpyright",
				"ruff",
				"clangd",
				"cmake",
				"jdtls",
				"texlab",
			},
			handlers = {
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,
				["lua_ls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								runtime = { version = "Lua 5.1" },
								diagnostics = {
									globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
								},
								format = {
									enable = true,
									defaultConfig = {
										indent_style = "tab",
										indent_size = "4",
									},
								},
							},
						},
					})
				end,

				["basedpyright"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.pyright.setup({
						capabilities = capabilities,
						settings = {
							python = {
								analysis = {
									typeCheckingMode = "off",
									autoImportCompletions = true,
									useLibraryCodeForTypes = true,
								},
							},
						},
					})
				end,

				["clangd"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.clangd.setup({
						capabilities = capabilities,
						cmd = {
							"clangd",
							"--background-index",
							"--clang-tidy",
							"--cross-file-rename",
							"--completion-style=detailed",
							"--header-insertion=iwyu",
							"--suggest-missing-includes",
						},
						-- stylua: ignore
						filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "h", "hpp", "hh", "m", "mm", "hh", "cc", "cxx", "hxx" },
						root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
					})
				end,
			},
		})
		local l = vim.lsp
		l.handlers["textDocument/hover"] = function(_, result, ctx, config)
			config = config or { border = "rounded", focusable = true }
			config.focus_id = ctx.method
			if not (result and result.contents) then
				return
			end
			local markdown_lines = l.util.convert_input_to_markdown_lines(result.contents)
			markdown_lines = vim.tbl_filter(function(line)
				return line ~= ""
			end, markdown_lines)
			if vim.tbl_isempty(markdown_lines) then
				return
			end
			return l.util.open_floating_preview(markdown_lines, "markdown", config)
		end

		local autocmd = vim.api.nvim_create_autocmd
		autocmd({ "BufEnter", "BufWinEnter" }, {
			pattern = { "*.vert", "*.frag", "*.hlsl" },
			callback = function(_)
				vim.cmd("set filetype=glsl")
			end,
		})

		autocmd("LspAttach", {
			callback = function(e)
				local opts = { buffer = e.buf }
				vim.keymap.set("n", "K", function()
					vim.lsp.buf.hover({
						border = "rounded",
					})
				end, opts)
				-- vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)
				vim.keymap.set("n", "<leader>la", function()
					vim.lsp.buf.code_action()
				end, { buffer = e.buf, desc = "Code action" })
				vim.keymap.set("n", "<leader>lr", function()
					vim.lsp.buf.rename()
				end, { buffer = e.buf, desc = "Rename symbol" })
				vim.keymap.set("n", "<leader>lk", function()
					vim.diagnostic.open_float()
				end, { buffer = e.buf, desc = "Open float" })
				vim.keymap.set("n", "<leader>ln", function()
					vim.diagnostic.goto_next()
				end, { buffer = e.buf, desc = "Goto next" })
				vim.keymap.set("n", "<leader>lp", function()
					vim.diagnostic.goto_prev()
				end, { buffer = e.buf, desc = "Goto previous" })
			end,
		})
	end,
}
