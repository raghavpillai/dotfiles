-- VSCode-like keymaps
-- These are set up as an autocmd so they load after LazyVim defaults

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    local map = vim.keymap.set

    -- Save with Ctrl+S
    map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

    -- Undo/Redo
    map("n", "<C-z>", "u", { desc = "Undo" })
    map("n", "<C-y>", "<C-r>", { desc = "Redo" })

    -- Select all
    map("n", "<C-a>", "ggVG", { desc = "Select all" })

    -- Duplicate line (like VSCode Shift+Alt+Down)
    map("n", "<S-A-Down>", "<cmd>t.<cr>", { desc = "Duplicate line down" })
    map("n", "<S-A-Up>", "<cmd>t -1<cr>", { desc = "Duplicate line up" })

    -- Move lines (like VSCode Alt+Up/Down)
    map("n", "<A-Up>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
    map("n", "<A-Down>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
    map("v", "<A-Up>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })
    map("v", "<A-Down>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })

    -- Comment toggle (Ctrl+/ like VSCode) — handled by LazyVim default gcc/gc

    -- Quick find file: Ctrl+P already mapped by LazyVim (telescope)
    -- Command palette: <leader><leader> already mapped by LazyVim
  end,
})

return {}
