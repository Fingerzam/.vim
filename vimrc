set nocompatible

call pathogen#infect()
syntax on
filetype plugin indent on

let mapleader = "å"
let maplocalleader = ","

if has('gui_running')
    set background=light
else
    set background=dark
endif
"language English

set shell=/bin/bash
set encoding=utf8 hidden sw=4 ts=4 et ai si
set backspace=indent,eol,start
set showmatch smarttab hlsearch incsearch history=1000
set undolevels=1000 wildignore=*.swp,*.bak,*.class,*~
set title noerrorbells undofile
set cursorline
set ttyfast
set laststatus=2
set showmode
set showcmd
set nonumber
set norelativenumber
set lazyredraw
set showbreak=→
set splitbelow
set splitright
set ttimeout
set notimeout
set backup
set fillchars+=diff:\ 
set virtualedit+=block
set foldlevelstart=0
set completeopt=longest,menuone,preview

nnoremap K <nop>
nnoremap <leader>s :%s//<left>

au VimResized * exe "normal! \<c-w>="

set shiftround
set clipboard=unnamed
set autowrite

set wildmenu
set wildmode=list:longest
set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.luac                           " Lua byte code
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.pyc                            " Python byte code
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store?                      " OSX bullshi
"set fillchars+=vert:\u2502

set backupskip=/tmp/*,/private/tmp/*

noremap <leader><space> :silent :noh<cr>:match none<cr>:2match none<cr>:3match none<cr>
nnoremap n nzzzv
nnoremap N Nzzzv

noremap H ^
noremap L $

noremap Y y$

" Fold
nnoremap <leader>z zMzvzz

set viminfo+=%

set list
set listchars=tab:▸\ ,extends:❯,precedes:❮,trail:.,nbsp:.
autocmd filetype html,xml,xhtml set listchars-=tab:>.

"magic search
nnoremap / /\v
vnoremap / \v

set ignorecase smartcase
set gdefault

nnoremap <space> :
"nicer j and k on long lines
nnoremap j gj
nnoremap k gk

map <C-h> <C-w>h
map <C-l> <C-w>l
map <C-j> <C-w>j
map <C-k> <C-w>k

"save file with root permissions
cmap w!! w !sudo tee % >/dev/null

set guioptions-=L
set guioptions-=R
set guioptions-=T
set guioptions-=m
set guioptions-=r
set guioptions-=l
set guioptions+=c

"set guifont=Menlo:h12

filetype on
filetype plugin indent on

syntax on
autocmd BufWritePost vimrc source %

let g:molokai_original = 1

colorscheme solarized

" syntastic

let g:syntastic_enable_signs = 1

set statusline=
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%{fugitive#statusline()}
set statusline+=%*
set statusline+=%=(%{&ff}/%Y)

imap <S-CR> o

" fugitive
nmap <leader>gc :Gcommit<cr>
nmap <leader>ga :Gcommit -a<cr>
nmap <leader>gp :Git push<cr>
nmap <leader>gl :Git pull<cr>
nmap <leader>gr :Git pull --rebase<cr>
nmap <leader>gs :Gstatus<cr>
nmap <leader>dd :Gdiff<cr>

nmap <leader>o :CommandT<cr>

nmap <leader><leader> <c-^>

" Settings for VimClojure
let vimclojure#DynamicHighlighting=1
let vimclojure#ParenRainbow=1
let vimclojure#FuzzyIndent = 1
