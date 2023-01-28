"status bar
"set statusline=2
set laststatus=2

" highlight syntax
syntax on

" show line numbers
set number

" highlight results
set hlsearch 

" ignore case in search results
set ignorecase 

" show search results as you type
set incsearch 

" wrap text
set wrap

call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'arcticicestudio/nord-vim'
call plug#end()

" powerline fonts for airline
" let g:airline_powerline_fonts = 1

" set airline theme
let g:airline_theme='bubblegum'
" others, base16, bubblegum, deus, wombat, luna, molokai, ubaryd

