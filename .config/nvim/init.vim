" default plugged dir on mac: ~/.local/share/nvim/plugged
" remind: :so %
:set number
:set relativenumber
:set autoindent
:set tabstop=8
:set shiftwidth=4
:set smarttab
:set softtabstop=0
:set expandtab
:set mouse=a
:set nowrap
set ignorecase                  " Search case insensitive...
set smartcase                   " ... but not when search pattern contains upper case characters
set noerrorbells                " No beeps
set autoindent
set tabstop=4 shiftwidth=4 expandtab
set foldmethod=indent
set noshowmode

" remove trailing whitespace at :w
autocmd BufWritePre * :%s/\s\+$//e

call plug#begin()

Plug 'tpope/vim-surround' " Surrounding ysw)
Plug 'preservim/nerdtree' " NerdTree
Plug 'tpope/vim-commentary' " For Commenting gcc & gc
Plug 'vim-airline/vim-airline' " Status bar
Plug 'vim-airline/vim-airline-themes' " Status bar themes
Plug 'arcticicestudio/nord-vim' " nord theme
Plug 'catppuccin/nvim', { 'as': 'catppuccin' } "catppuccin theme
Plug 'ap/vim-css-color' " CSS Color Preview
Plug 'rafi/awesome-vim-colorschemes' " Retro Scheme
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Auto Completion
Plug 'ryanoasis/vim-devicons' " Developer Icons
Plug 'tc50cal/vim-terminal' " Vim Terminal
Plug 'terryma/vim-multiple-cursors' " CTRL + N for multiple cursors
Plug 'fatih/vim-go'
Plug 'junegunn/fzf.vim'
Plug 'dracula/vim', { 'as': 'dracula' }
" Plug 'glepnir/dashboard-nvim'  " may require nvim w lua
Plug 'nvim-lua/plenary.nvim' " req for telescope
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.1' } " fuzzy finder
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " recc for telescope
Plug 'BurntSushi/ripgrep'
Plug 'vimwiki/vimwiki'
Plug 'preservim/tagbar' " Tagbar for code navigation - must apt intall exuberant-ctags

set encoding=UTF-8

call plug#end()

" COLORSCHEME ------------------------------------------------------------ {{{
" transparent background
augroup user_colors
  autocmd!
  autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
augroup END

" colorscheme dracula
colorscheme catppuccin-macchiato

" MAPPINGS --------------------------------------------------------------- {{{

" ---- NERDTree specific mappings:
" Map the F3 key to toggle NERDTree open and close.
nnoremap <F3> :NERDTreeToggle<cr>

" Have nerdtree ignore certain files and directories.
let NERDTreeIgnore=['\.git$', '\.jpg$', '\.mp4$', '\.ogg$', '\.iso$', '\.pdf$', '\.pyc$', '\.odt$', '\.png$', '\.gif$', '\.db$']

" ---- COC.NVIM mappings:
"remap <cr> to make it confirm completion
inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

" use <tab> to trigger completion and navigate to the next complete item
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <Tab>

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" remap vimwiki followlinks so that it does not interfere with coc tab
" autocomplete
inoremap <leader>wf <Plug>VimwikiFollowLink
inoremap <leader>wn <Plug>VimwikiNextLink

" ....still trying to override vimwiki mappings :/
let g:vimwiki_key_mappings = { 'table_mappings': 0 }

let mapleader=","

" }}}

:set completeopt-=preview " For No Previews

":colorscheme jellybeans
let g:airline_theme='bubblegum'

" --- Just Some Notes ---
" :PlugClean :PlugInstall :UpdateRemotePlugins
" :CocInstall coc-python
" :CocInstall coc-clangd
" :CocInstall coc-snippets
" :CocCommand snippets.edit... FOR EACH FILE TYPE


" air-line
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ' 󰫣'
let g:airline_symbols.dirty='⚡'

" use tab to coc autocomplete
inoremap <expr> <Tab> pumvisible() ? coc#_select_confirm() : "<Tab>"
" use <cr> to auto complete for coc
inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
" for python support in terminal
let g:python3_host_prog = '/usr/bin/python3'

" auto close brackets etc
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O
inoremap <expr> ) strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"
inoremap <expr> } strpart(getline('.'), col('.')-1, 1) == "}" ? "\<Right>" : "}"
inoremap <expr> ] strpart(getline('.'), col('.')-1, 1) == "]" ? "\<Right>" : "]"
inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "\'" ? "\<Right>" : "\'\'\<Left>"
inoremap <expr> " strpart(getline('.'), col('.')-1, 1) == "\"" ? "\<Right>" : "\"\"\<Left>"

" no perl provider - advised from :checkhealth
let g:loaded_perl_provider = 0

" customize righthand side of airline
"au User AirlineAfterInit  :let g:airline_section_z = airline#section#create(['windowswap', 'obsession', '%3p%%'])
au User AirlineAfterInit  :let g:airline_section_z = airline#section#create(['󰫣 %L::%1v'])

" VIMWIKI
" let g:vimwiki_list = [{'path': '~/Documents/obsidian_notes/'}]
let g:vimwiki_list = [{'path': '~/Documents/obsidian_notes/', 'syntax': 'markdown', 'ext': '.md'}]
