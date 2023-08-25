vim.g.mapleader = " "

local function map(mode, lhs, rhs, options)
    options = options or { noremap = true, silent = true }
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local aucmd_dict = {
    FileType = {
        {
            pattern = { "arduino" },
            callback = function()
                map("n", "<leader>vf", "va{V", { noremap = false, silent = true })
                map(
                    "n",
                    "<leader><CR>",
                    '<ESC><CMD>2TermExec cmd="arduino-cli compile --fqbn esp8266:esp8266:nodemcuv2 && arduino-cli upload -v -p /dev/ttyACM0 --fqbn esp8266:esp8266:nodemcuv2:baud=3000000 && arduino-cli monitor -p /dev/ttyACM0 -c baudrate=115200" direction=float<CR>'
                )
            end,
        },
        {
            pattern = { "sh" },
            callback = function()
                map("n", "<leader><CR>", '<ESC><CMD>2TermExec cmd="bash %" direction=horizontal<CR>')
                map("n", "<leader><CR><CR>", '<ESC><CMD>2TermExec cmd="bash %" direction=horizontal<CR><C-w>j')
            end,
        },
        {
            pattern = { "c", "cpp" },
            callback = function()
                map("n", "<leader>vf", "va{V", { noremap = false, silent = true })
                -- map('n', '<leader><CR>', '<ESC><CMD>2TermExec cmd="cc % -Wall -Wextra -Werror -o main && ./main" direction=vertical<CR>')
                map(
                    "n",
                    "<leader><CR>",
                    '<ESC><CMD>2TermExec cmd="cc % -Wall -Wextra -Werror -o main && ./main" direction=horizontal<CR>'
                )
                -- map('n', '<leader><CR>', '<ESC><CMD>2TermExec cmd="cc % -lm -o main && ./main" direction=vertical<CR>')
                map(
                    "n",
                    "<leader><CR><CR>",
                    '<ESC><CMD>2TermExec cmd="cc % -lm -o main && ./main" direction=horizontal<CR><C-w><C-w>'
                )
            end,
        },
        {
            pattern = { "rs", "rust" },
            callback = function()
                map("n", "<leader>vf", "va{V", { noremap = false, silent = true })
                map("n", "<leader><CR>", '<ESC><CMD>2TermExec cmd="cargo run" direction=horizontal<CR>')
                -- map('n', '<leader><CR>', '<ESC><CMD>3TermExec cmd="cargo run" direction=horizontal<CR><C-w>j')
            end,
        },
        {
            pattern = { "markdown" },
            callback = function()
                map("n", "<leader><CR>", "<ESC><CMD>Glow %<CR>")
            end,
        },
        {
            pattern = { "python" },
            callback = function()
                map("n", "<leader>vf", "[[V]M", { noremap = false, silent = true })
                map("n", "<leader><CR>", '<ESC><CMD>2TermExec cmd="python %" direction=horizontal<CR>')
            end,
        },
    },
}
map("n", "<leader>S", '<cmd>lua require("spectre").open()<CR>', {
    desc = "Open Spectre",
})
map("n", "<leader>Sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
    desc = "Search current word",
})
map("v", "<leader>Sw", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
    desc = "Search current word",
})
map("n", "<leader>Sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
    desc = "Search on current file",
})
for event, opt_tbls in pairs(aucmd_dict) do
    for _, opt_tbl in pairs(opt_tbls) do
        vim.api.nvim_create_autocmd(event, opt_tbl)
    end
end

function _G.set_terminal_keymaps()
    local opts = { buffer = 0 }
    vim.keymap.set("t", "<ESC>", [[<C-\><C-n><CMD>wincmd k<CR>]], opts)
    vim.keymap.set("t", "<C-q>", [[<C-\><C-n>]], opts)
    -- vim.keymap.set("t", "<A-q>", [[<C-\><C-n><CMD>ToggleTerm<CR>]], opts)
    -- vim.keymap.set("t", "<C-h>", [[<CMD>wincmd h<CR>]], opts)
    -- vim.keymap.set("t", "<C-j>", [[<CMD>wincmd j<CR>]], opts)
    -- vim.keymap.set("t", "<C-k>", [[<CMD>wincmd k<CR>]], opts)
    -- vim.keymap.set("t", "<C-l>", [[<CMD>wincmd l<CR>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
vim.cmd("autocmd! TermEnter term://* set nospell")

map("t", "<ESC>", "<C-\\><C-n><CMD>wincmd k<CR>")
map("t", "<A-q>", "<C-\\><C-n>")
map("t", "<A-1>", "<C-\\><C-n><CMD>ToggleTerm<CR>")
map("t", "<A-2>", "<C-\\><C-n><CMD>ToggleTerm<CR>")

function ChangeScaleFactor(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end

map("n", "<C-=>", ":lua ChangeScaleFactor(1.1)<CR>")
map("n", "<C-->", ":lua ChangeScaleFactor(0.9)<CR>")

-- Go to URL in current line
M = {}
M.HandleURL = function()
    local url = string.match(vim.fn.getline("."), "%f[%a]([a-zA-Z]+://[^%s,;\"'<>%(%)]*)")
    if url ~= "" then
        vim.cmd("exec '!xdg-open " .. url .. "'")
    else
        vim.cmd('echo "No URI found in line."')
    end
end
map("n", "gf", "<Cmd>lua M.HandleURL()<CR>")

-- Find files using Telescope command-line sugar.
map("n", "<leader>ff", "<CMD>Telescope find_files<CR>")
map("n", "<leader>fg", "<CMD>Telescope live_grep<CR>")
map("n", "<leader>fb", "<CMD>Telescope buffers<CR>")
map("n", "<leader>fh", "<CMD>Telescope help_tags<CR>")
map("n", "<leader>gg", "<CMD>LazyGitCurrentFile<CR>", { noremap = true, silent = true })
map("n", "<leader>gd", "<CMD>Gitsigns diffthis<CR>", { noremap = true, silent = true })
map("n", "<A-e>", "<CMD>NeoTreeFloatToggle<CR>", { noremap = true, silent = true })
-- map('n', '<A-b>', '<CMD>NeoTreeFloat buffers<CR>', {noremap = true, silent = true})
map("n", "<A-b>", "<CMD>Telescope buffers<CR>", { noremap = true, silent = true })
map("n", "<leader>r", ':so %<CR><CMD>echo "Settings reload!"<CR>')
map("n", "<leader>e", "<CMD>TroubleToggle document_diagnostics<CR>")
map("n", "<leader>E", "<CMD>TroubleToggle workspace_diagnostics<CR>")
map("n", "<leader>u", "<CMD>PackerUpdate<CR><CMD>Mason<CR>")
map("n", "<leader>i", "<CMD>IconPickerInsert emoji<CR>")
map("n", "<A-1>", "<ESC><CMD>1ToggleTerm direction=float<CR>")
map("n", "<A-2>", "<ESC><CMD>2ToggleTerm direction=horizontal<CR>")
map("n", "<A-3>", "<ESC><CMD>3ToggleTerm direction=float<CR>")
map("n", "<leader>ve", "<CMD>lua require('swenv.api').pick_venv()<CR>")
map("n", "<leader>o", "<CMD>TagbarOpenAutoClose<CR>")
map("n", "<leader>a", "<CMD>AerialToggle float<cr>")
map("n", "<A-z>", "<CMD>ZenMode<CR>")
map("n", "<F1>", "<CMD>Header42<CR>")
map("n", "<A-CR>", ":", { noremap = true, silent = false })
map("", "<leader>s", "<CMD>set spell!<CR>")

-- Not rewrite clipboard
-- map('n', 'd', '"_d')
map("", "s", '"_s')
map("", "x", '"_x')
map("", "X", '"_X')
map("", "<Del>", '"_x')
map("", "<S-Del>", '"_dd')
map("i", "<S-Del>", '<ESC>"_dd')
-- Edit words with copy and paste
-- map('n', '<A-CR>', 'b"_ce')
-- map('i', '<A-CR>', '<ESC>b"_ce')
map("n", "<A-i>", 'b"_ce')
map("n", "<A-p>", 'b"_ce<ESC>p')
-- map('i', '<A-p>', '<ESC>b"_ce<ESC>pi')
map("n", "<A-y>", "byew")
map("i", "<A-y>", "<ESC>byew")

map("n", "<F2>", '<CMD>lua require("renamer").rename()<CR>')
map("i", "<F2>", '<CMD>lua require("renamer").rename()<CR>')
map("v", "<F2>", '<CMD>lua require("renamer").rename()<CR>')

-- Debugger
map("n", "<F7>", "<CMD>DapToggleBreakpoint<CR>")
map("n", "<F8>", "<CMD>DapContinue<CR>")
map("n", "<F9>", "<CMD>DapStepInto<CR>")
map("n", "<F10>", "<CMD>DapTerminate<CR>")
map("n", "<F12>", '<CMD>lua require("dapui").toggle()<CR>')

-- Windows and Tabs
map("", "<leader><Tab>", "<C-w>w")
map("n", "<C-S-Up>", "<C-w><Up>")
map("n", "<C-S-Down>", "<C-w><Down>")
map("n", "<C-S-Left>", "<C-w><Left>")
map("n", "<C-S-Right>", "<C-w><Right>")
map("n", "<C-S-H>", "<CMD>vertical resize -4<CR>")
map("n", "<C-S-J>", "<CMD>horizontal resize +4<CR>")
map("n", "<C-S-K>", "<CMD>horizontal resize -4<CR>")
map("n", "<C-S-L>", "<CMD>vertical resize +4<CR>")
map("n", "<C-S-PageUp>", "<CMD>BufferLineMovePrev<CR>")
map("n", "<C-S-PageDown>", "<CMD>BufferLineMoveNext<CR>")

-- map("n", "<A-->", '"_dd')
-- map("i", "<A-->", '<ESC>"_ddi')
-- map("n", "<C-d>", '"_dd')
-- map("i", "<C-d>", '<ESC>"_ddi')
map("n", "<A-d>", "yyp")
map("i", "<A-d>", "<ESC>yypi")
map("v", "<A-d>", "ygv<ESC>pgv")
map("n", "<C-s>", "<CMD>w<CR>")
map("n", "<A-s>", "<CMD>w<CR>")
map("i", "<A-s>", "<ESC><CMD>w<CR>")
map("v", "<A-s>", "<ESC><CMD>w<CR>")
map("i", "<C-s>", "<ESC><CMD>w<CR>")
map("v", "<C-s>", "<ESC><CMD>w<CR>")
map("s", "<C-s>", "<ESC><CMD>w<CR>")
map("n", "<C-z>", "<CMD>undo<CR>")
map("n", "<S-u>", "<CMD>redo<CR>")
map("n", "<C-Space>", "<CMD>NeoTreeFocusToggle<CR>")
map("n", "<A-q>", '<CMD>lua require("dapui").close()<CR><CMD>SClose<CR>')

map("i", "<A-/>", "<ESC><CMD>CommentToggle<CR>i<Right>")
map("n", "<A-/>", "<S-V><ESC><CMD>'<,'>CommentToggle<CR>gv<ESC>")
map("v", "<A-/>", "<ESC><CMD>'<,'>CommentToggle<CR>gv<ESC>")
map("i", "<A-u>", "<ESC><CMD>CommentToggle<CR>i<Right>")
map("n", "<A-u>", "<S-V><ESC><CMD>'<,'>CommentToggle<CR>gv<ESC>")
map("v", "<A-u>", "<ESC><CMD>'<,'>CommentToggle<CR>gv<ESC>")

map("i", "<C-PageDown>", "<ESC><CMD>bnext<CR>")
map("i", "<C-PageUp>", "<ESC><CMD>bprevious<CR>")
map("n", "<C-PageDown>", "<CMD>bnext<CR>")
map("n", "<C-PageUp>", "<CMD>bprevious<CR>")
map("n", "<A-a>", "ggVGo")

-- Move lines up and down
map("i", "<A-Up>", "<ESC><CMD>m .-2<CR>==gi")
map("n", "<A-Up>", "<CMD>m .-2<CR>==")
map("v", "<A-Up>", "<ESC><CMD>'<,'>m '<-2<CR>gv")
map("i", "<A-Down>", "<ESC><CMD>m .+1<CR>==gi")
map("n", "<A-Down>", "<CMD>m .+1<CR>==")
map("v", "<A-Down>", "<ESC><CMD>'<,'>m '>+1<CR>gv=gv")

-- Normal and Visual mode
map("n", "<CR>", "i")
map("n", "<C-i>", "<C-I>")
map("n", "<leader>tr", "<CMD>Telescope registers<CR>")
map("n", "<A-l>", "w")
map("n", "<A-[>", "ysiw", { noremap = false, silent = true })
map("n", "<A-]>", "ds", { noremap = false, silent = true })
map("n", "<A-9>", "ysiwb", { noremap = false, silent = false })
map("n", "<A-0>", "dsb", { noremap = false, silent = false })
map("n", "<A-,>", "ysiwt", { noremap = false, silent = false })
map("n", "<A-.>", "dst", { noremap = false, silent = false })
map("v", "<A-,>", "ST", { noremap = false, silent = false })
map("n", "<C-\\>", "<CMD>vsplit<CR><C-w>l<CR>:bnext<CR>")
map("n", "<C-/>", "<CMD>split<CR><C-w>j<CR>:bnext<CR>")
map("n", "<C-q>", "<C-w>q")
map("n", "<A-Home>", "<CMD>vertical resize -2<CR>")
map("n", "<A-End>", "<CMD>vertical resize +2<CR>")
map("n", "<A-Del>", "ce")
map("n", "<A-Backspace>", "cb")
map("n", "<A-x>", '"_dd')
map("i", "<A-x>", '<ESC>"_dd')
map("n", "<A-o>", "o<ESC>")
-- map('n', '<A-x>', '"_dw')

map("n", "<leader><Left>", "za")
map("n", "<leader><Up>", "zM")
map("n", "<leader><Down>", "zR")
map("n", "<leader>h", "za")
map("n", "<leader>j", "zR")
map("n", "<leader>k", "zM")

map("n", "<A-j>", "<CMD>m .+1<CR>==")
map("v", "<A-j>", "<ESC><CMD>'<,'>m '>+1<CR>gv=gv")
map("n", "<A-k>", "<CMD>m .-2<CR>==")
map("v", "<A-k>", "<ESC><CMD>'<,'>m '<-2<CR>gv=gv")
map("n", "<A-h>", "b")
map("n", "<C-j>", "<CMD>bprevious<CR>")
map("n", "<C-k>", "<CMD>bnext<CR>")

-- Insert mode
-- Movements
map("i", "<A-j>", "<Down>")
map("i", "<A-k>", "<Up>")
map("i", "<A-h>", "<Left>")
map("i", "<A-l>", "<Right>")
map("i", "<S-A-h>", "<C-o>b")
map("i", "<S-A-l>", "<C-o>w")

-- map('i', '<A-u>', '<ESC>ui')
map("n", "<A-m>", "<ESC>o")
map("i", "<A-i>", "<ESC><Right>")

map("i", "<A-,>", "<ESC>lylli, <ESC>ppi")

map("i", "<A-Left>", "<C-o>b")
map("i", "<A-Right>", "<C-o>e")

map("i", "<A-z>", "<Backspace>")
map("i", "<A-x>", "<Del>")
map("i", "<A-g>", "<Home>")
map("i", "<A-;>", "<End>")
map("i", "<A-Del>", "<C-o>de")
map("i", "<A-Backspace>", "<C-o>db")
map("i", "<A-S-Del>", "<C-o>die")
map("i", "<A-S-Backspace>", "<C-o>dib")

map("n", "<A-Left>", "<C-w>h")
map("n", "<A-Right>", "<C-w>l")
map("n", "<A-PageDown>", "<CMD>bnext<CR>")
map("i", "<A-PageDown>", "<ESC><CMD>bnext<CR>")
map("n", "<A-PageUp>", "<CMD>bprevious<CR>")
map("i", "<A-PageUp>", "<ESC><CMD>bprevious<CR>")
map("i", "<A-w>", "<ESC><CMD>Bdelete<CR>")
map("n", "<A-w>", "<CMD>Bdelete<CR>")
map("n", "<A-t>", "cstt")

-- retab
map("n", "<Tab>", ">>_")
map("n", "<S-Tab>", "<<_")
map("i", "<S-Tab>", "<C-D>")
map("v", "<Tab>", ">gv")
map("v", "<S-Tab>", "<gv")

-- Select with shift + arrows
map("i", "<S-Left>", "<Left><C-o>v")
map("i", "<S-Right>", "<C-o>v")
map("i", "<S-Up>", "<Left><C-o>v<Up><Right>")
map("i", "<S-Down>", "<C-o>v<Down><Left>")
map("i", "<C-S-Left>", "<S-Left><C-Left>")
map("i", "<C-S-Right>", "<S-Right><C-Right>")
map("v", "<S-Left>", "<Left>")
map("v", "<S-Right>", "<Right>")
map("v", "<S-Up>", "<Up>")
map("v", "<S-Down>", "<Down>")
map("n", "<S-Down>", "V<Down>")
map("n", "<S-Up>", "V<Up>")

-- Auto unselect when not holding shift
map("v", "<Left>", "<Esc>")
map("v", "<Right>", "<Esc><Right>")
map("v", "<Up>", "<Esc><Up>")
map("v", "<Down>", "<Esc><Down>")

-- Keybind to clear search
map("n", "<leader>c", '<CMD>nohl<CR><CMD>echo "Search Cleared"<CR>')

map("n", "<C-c>", "<CMD>PickColor<CR>", { noremap = true, silent = true })
map("i", "<C-c>", "<CMD>PickColorInsert<CR>", { noremap = true, silent = true })

-- Debug + tests
-- map("", "<F4>", "<CMD>lua require('neotest').summary.toggle()<CR>", { noremap = true, silent = true })
map("", "<leader>tt", "<CMD>lua require('neotest').summary.toggle()<CR>")
