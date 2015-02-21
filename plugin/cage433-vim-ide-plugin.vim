let mapleader=","
inoremap jk <ESC>
noremap <silent> <leader>sv :source $MYVIMRC<CR>
noremap <silent> <leader>se :e $MYVIMRC<CR>

set wrap        
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set autoindent    " always set autoindenting on
set copyindent    " copy the previous indentation on autoindenting
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'
set showmatch     " set show matching parenthesis
"set ignorecase    " ignore case when searching
set smartcase     " ignore case if search pattern is all lowercase,  case-sensitive otherwise
set smarttab      " insert tabs on the start of a line according to shiftwidth, not tabstop
set incsearch     " show search matches as you type
set gdefault
set nobackup
set noswapfile
set nopaste
set lazyredraw
set nomodeline
set fileformats+=dos

nnoremap ; :
nnoremap <leader>m ;
vnoremap ; :
vnoremap <leader>m ;
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap j gj
nnoremap k gk



:set tabstop=2
:set shiftwidth=2
:set expandtab

:set gdefault

set encoding=utf-8
set scrolloff=3
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
set cursorline
set ttyfast
set backspace=indent,eol,start

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
" Taken from https://github.com/garybernhardt/dotfiles
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>

noremap <silent> <F3> :call BufferList()<CR>

nnoremap <leader>, <C-^>

let g:ctrlp_map = ',f'
let g:ctrlp_working_path_mode = 0
let g:ctrlp_by_filename = 1
let g:ctrlp_dotfiles = 0
let g:ctrlp_custom_ignore = '\.git$\|\.xml$|\.fasl$|\.class$'

let g:ackprg="ack-grep --type=noxml -H --nocolor --nogroup --column"

set efm=[error]\ %f:%l:\ %m
nnoremap <leader>ee :cfile vim-compilation-errors<CR>:copen<CR><CR>
nnoremap <leader>en :cn<CR>
nnoremap <leader>ep :cp<CR>

function! RefreshTags()
    exec "silent ! scala-tags.sh"
    redraw!
endfunction
command! RefreshCTags call RefreshTags()
noremap <leader>ct :silent :call RefreshTags()<CR>

let g:orientation="landscape"
function! ToggleSplit()
  if winnr("$") == 1
    if g:orientation == "landscape"
      vsplit
    else
      split
    endif
  else
    only
  endif
endfunction
map <silent> <F10> :call ToggleSplit()<CR>

function! TogglePaste()
  set paste!
  if &paste
    echo "Paste On"
  else
    echo "Paste Off"
  endif
endfunction
noremap <silent> <F4> :call TogglePaste()<CR>


syntax enable
set t_Co=16
let g:dark_view=1
set background=dark
colorscheme solarized
let g:solarized_termtrans=1
" let g:solarized_termcolors=256
set wildignore+=*.jar
set wildignore+=*.class

syntax on
