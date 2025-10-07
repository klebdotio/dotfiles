vim.g.mapleader = " "

local set = vim.keymap.set

local function desc(description)
	return { noremap = true, silent = true, desc = description }
end

-- mistypes
vim.cmd([[cabbrev W w]])
vim.cmd([[cabbrev Q q]])
vim.cmd([[cabbrev Wq wq]])
vim.cmd([[cabbrev WQ wq]])
vim.cmd([[cabbrev wQ wq]])

-- useful
set({ "n", "v", "x" }, "<leader>y", '"+y', desc("Yank to system clipboard"))
set({ "n" }, "<leader>A", "ggVG", desc("Select all"))
set({ "x" }, "/", "<esc>/\\%V", desc("Search in selection"))
-- moving lines
set("i", "<A-j>", "<Esc>:m .+1<cr>==gi", desc("Move line down"))
set("i", "<A-k>", "<Esc>:m .-2<cr>==gi", desc("Move line up"))
set({ "n" }, "<A-j>", ":m .+1<cr>==", desc("Move line down"))
set({ "n" }, "<A-k>", ":m .-2<cr>==", desc("Move line up"))
set({ "x" }, "<A-j>", ":m '>+1<CR>gv=gv", desc("Move lines down"))
set({ "x" }, "<A-k>", ":m '<-2<CR>gv=gv", desc("Move lines up"))
-- indenting
set({ "v" }, "<", "<gv", desc("Unindent and stay in visual"))
set({ "v" }, ">", ">gv", desc("Indent and stay in visual"))
-- toggles
set({ "n" }, "<leader>z", function()
	vim.wo.wrap = not vim.wo.wrap
	print("Line wrapping is " .. (vim.wo.wrap and "ON" or "OFF"))
end, desc("Toggle wrapping"))