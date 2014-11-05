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

" disable arrow navigation keys
inoremap  <Up>    <NOP>
inoremap  <Down>  <NOP>
inoremap  <Left>  <NOP>
inoremap  <Right> <NOP>
noremap   <Up>    <NOP>
noremap   <Down>  <NOP>
noremap   <Left>  <NOP>
noremap   <Right> <NOP>

" show line numbers
set number

" format JSON
nnoremap <leader>j :%!python -m json.tool<cr>

" ignore ruby warnings in Syntastic
let g:syntastic_ruby_mri_args="-T1 -c"

" syntax highlighting for .ejs and .hamlc
au BufNewFile,BufRead *.ejs set filetype=html
au BufNewFile,BufRead *.hamlc set filetype=html

" git commit messages get 50/72 vertical bars
autocmd BufNewFile,BufRead COMMIT_EDITMSG set colorcolumn=50,72

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
nnoremap <leader><bs> :Ag! '\b<c-r><c-w>\b'<cr>

" keep foreground commands in sync
map fg <c-z>

" ctrlp.vim config
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_working_path_mode = 'a'
let g:ctrlp_max_height = 20
let g:ctrlp_match_window_bottom = 0
let g:ctrlp_switch_buffer = 0

" NERDTree configuration
let NERDTreeIgnore=['\~$', 'tmp', '\.git', '\.bundle', '.DS_Store', 'tags', '.swp']
let NERDTreeShowHidden=1
map <Leader>n :NERDTreeToggle<CR>
map <Leader>fnt :NERDTreeFind<CR>

" Use binstubs for rspec and cucumber
let g:turbux_command_cucumber="bin/cucumber -rfeatures"
let g:turbux_command_rspec="bin/rspec"

set softtabstop=2 shiftwidth=2 expandtab

if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif

if getcwd() != $HOME && getcwd() != $DOTFILES_DIR
  if filereadable(expand('.vimrc'))
    source .vimrc
  endif
endif

command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
function! QuickfixFilenames()
  " Building a hash ensures we get each buffer only once
  let buffer_numbers = {}
  for quickfix_item in getqflist()
    let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
  endfor
  return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction

" Disable vim backups
set nobackup

" Store swap files named by their path in common directory to reduce git noise
" and avoid false starts by test suite file watchers
set directory=~/.vim/.swp//
