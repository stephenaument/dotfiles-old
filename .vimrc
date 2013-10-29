runtime! autoload/pathogen.vim
if exists('g:loaded_pathogen')
  execute pathogen#infect('~/.vimbundles/{}')
endif

syntax on
filetype plugin indent on

set visualbell

set wildmenu
set wildmode=list:longest,full

set splitright
set splitbelow

set hidden

set guifont=Monaco:h16
set guioptions-=T guioptions-=e guioptions-=L guioptions-=r
set shell=bash

augroup vimrc
  autocmd!
  autocmd GuiEnter * set columns=120 lines=70 number
augroup END

" Add comma as leader
:nmap , \

map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" vim tab navigation
nnoremap th :tabfirst<CR>
nnoremap tj :tabprev<CR>
nnoremap tk :tabnext<CR>
nnoremap tl :tablast<CR>
nnoremap tc :tabclose<CR>
nnoremap tn :tabnew<CR>

" format JSON
nnoremap <leader>j :%!python -m json.tool<cr>

" save with enter
nmap <CR> :write!<CR>
"cabbrev w nope

" ignore ruby warnings in Syntastic
let g:syntastic_ruby_mri_args="-T1 -c"

" syntax highlighting for .ejs and .hamlc
au BufNewFile,BufRead *.ejs set filetype=html
au BufNewFile,BufRead *.hamlc set filetype=html

" Better search behavior
set hlsearch
set incsearch
set ignorecase
set smartcase

" Unhighlight search results
map <Leader><space> :nohl<cr>

" Don't scroll off the edge of the page
set scrolloff=5

" This uses Ack.vim to search for the word under the cursor
nnoremap <leader><bs> :Ack '\b<c-r><c-w>\b'<cr>

if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif
