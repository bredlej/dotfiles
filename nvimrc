" those 3 lines are needed to read vanilla vim config correctly
" https://vi.stackexchange.com/questions/12794/how-to-share-config-between-vim-and-neovim
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc

set undofile
set undodir=~/.local/share/nvim/undo//
set backup
set backupdir=~/.local/share/nvim/backup//

nnoremap <leader>vn :e ~/.config/nvim/init.vim<CR>

" source ~/.vim/plugged/nvim-lspconfig/plugin/lspconfig.vim

call plug#begin('~/.vim/plugged')
	Plug 'neovim/nvim-lsp'
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'neovim/nvim-lspconfig'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/nvim-cmp'

    " For vsnip users.
    Plug 'hrsh7th/cmp-vsnip'
    Plug 'hrsh7th/vim-vsnip'
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-telescope/telescope.nvim'
	Plug 'mfussenegger/nvim-dap'
	Plug 'Shatur/neovim-cmake'
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	Plug 'p00f/godbolt.nvim', {'branch' : 'main'}
	Plug 'prabirshrestha/vim-lsp'
	Plug 'morhetz/gruvbox'
    " For luasnip users.
    " Plug 'L3MON4D3/LuaSnip'
    " Plug 'saadparwaiz1/cmp_luasnip'

    " For ultisnips users.
    " Plug 'SirVer/ultisnips'
    " Plug 'quangnguyen30192/cmp-nvim-ultisnips'

    " For snippy users.
    " Plug 'dcampos/nvim-snippy'
    " Plug 'dcampos/cmp-snippy'
call plug#end()

colorscheme gruvbox
" source ~/.vim/plugged/plugins/nvim-cmp.vim

lua << EOF
-- require'lspconfig'.hls.setup{}
require'lspconfig'.ccls.setup{
  init_options = {
    compilationDatabaseDirectory = "build";
    index = {
      threads = 0;
    };
    clang = {
      extraArgs = { "-std=c++20" }
    };
  }
}

require('telescope').load_extension('cmake')

require("godbolt").setup({
    c = { compiler = "cg112", options = {} },
    cpp = { compiler = "g112", options = {} },
    rust = { compiler = "r1560", options = {} },
    -- any_additional_filetype = { compiler = ..., options = ... },
    quickfix = {
        enable = false, -- whether to populate the quickfix list in case of errors
        auto_open = false -- whether to open the quickfix list if the compiler outputs errors
    }
})
EOF

if executable('ccls')
    au User lsp_setup call lsp#register_server({
      \ 'name': 'ccls',
      \ 'cmd': {server_info->['ccls']},
      \ 'root_uri': {server_info->lsp#utils#path_to_uri(
      \   lsp#utils#find_nearest_parent_file_directory(
      \     lsp#utils#get_buffer_path(), ['.ccls', 'compile_commands.json', '.git/']))},
      \ 'initialization_options': {
      \   'highlight': { 'lsRanges' : v:true },
      \   'cache': {'directory': stdpath('cache') . '/ccls' },
      \ },
      \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
      \ })
endif
