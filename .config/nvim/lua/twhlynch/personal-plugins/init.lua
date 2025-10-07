local DEBUG = false

local function load_plugin(name, opts)
	opts = opts or {}
	opts.debug = opts.debug or DEBUG

	local plugin = require("twhlynch.personal-plugins." .. name)
	if plugin.setup then
		plugin.setup(opts)
	end

	return plugin
end
-- oil git integration
local oil_git = load_plugin("oil-git", {
	highlight = {
		OilGitAdded = { fg = "#7fa563" },
		OilGitModified = { fg = "#f3be7c" },
		OilGitDeleted = { fg = "#d8647e" },
		OilGitRenamed = { fg = "#cba6f7" },
		OilGitUntracked = { fg = "#c48282" },
	},
})

-- h and l open and close folds
local origami = load_plugin("origami", {})
